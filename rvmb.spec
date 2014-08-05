%define APP_BUILD_DATE %(date +'%%Y%%m%%d_%%H%%M')

Name:       rvmb
Summary:    Rapid VM builder for qemu-kvm based portable VMs
Version:    1.0.0
Release:    1
Group:      Development/Tools
License:    LGPL v2.1
BuildArch:  noarch
URL:        http://safrm.net/projects/rvmb
Vendor:     Miroslav Safr <miroslav.safr@gmail.com>
Source0:    %{name}-%{version}.tar.bz2
Autoreq: on
Autoreqprov: on
BuildRequires:  appver >= 1.1.1
BuildRequires: jenkins-support-scripts >= 1.2.4
Requires: qemu 
Requires: kvm 
Requires: openssh-clients
Requires: socat

%description
Rapid VM builder for qemu-kvm based portable VMs

%prep
%setup -c -n ./%{name}-%{version}

%build
jss-docs-update ./doc -sv %{version} 

%install
rm -fr %{buildroot}
mkdir -p %{buildroot}%{_bindir}
install -m 755 ./rvmb %{buildroot}%{_bindir}
sed -i".bkp" "1,/^VERSION=/s/^VERSION=.*/VERSION=%{version}/" %{buildroot}%{_bindir}/rvmb && rm -f %{buildroot}%{_bindir}/rvmb.bkp
sed -i".bkp" "1,/^VERSION_DATE=/s/^VERSION_DATE=.*/VERSION_DATE=%{APP_BUILD_DATE}/" %{buildroot}%{_bindir}/rvmb && rm -f %{buildroot}%{_bindir}/rvmb.bkp

mkdir -p -m 0755 %{buildroot}%{_sysconfdir}/bash_completion.d
install -m 0777 -v ./rvmb_completion %{buildroot}%{_sysconfdir}/bash_completion.d

mkdir -p  %{buildroot}%{_sysconfdir}/rvmb/targets
TARGETS=`find ./targets -type f`
install -m 755 $TARGETS %{buildroot}%{_sysconfdir}/rvmb/targets

mkdir -p %{buildroot}%{_mandir}/man1
install -m 644 ./doc/manpages/rvmb.1* %{buildroot}%{_mandir}/man1/

%clean
rm -fr %{buildroot}

%check
for TEST in $(  grep -r -l -h "#\!/bin/sh" . )
do
		sh -n "$TEST"
		if  [ $? != 0 ]; then
			echo "syntax error in $TEST, exiting.." 
			exit 1
		fi
done 

%files
%defattr(-,root,root,-)
%{_bindir}/rvmb
%dir %{_sysconfdir}/rvmb/targets
%{_sysconfdir}/rvmb/targets/*
%{_sysconfdir}/bash_completion.d/rvmb_completion
%{_mandir}/man1/rvmb.1*

