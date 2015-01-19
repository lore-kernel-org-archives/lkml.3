Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbbASOeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:34:00 -0500
Received: from mga14.intel.com ([192.55.52.115]:14887 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbbASOd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:33:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,427,1418112000"; 
   d="scan'208";a="664074028"
Date: Mon, 19 Jan 2015 22:33:39 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: kbuild-all@01.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [kvm:master 1/1] arch/x86/kvm/../../../virt/kvm/kvm_main.c:2062:25:
 sparse: incorrect type in assignment (different address spaces)
Message-ID: <201501192223.rdrTzdYB%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/virt/kvm/kvm.git master
head:   cdef511985374dd042a40bb32c1c346c2662c9dc
commit: cdef511985374dd042a40bb32c1c346c2662c9dc [1/1] KVM: fix sparse warning in include/trace/events/kvm.h
reproduce:
  # apt-get install sparse
  git checkout cdef511985374dd042a40bb32c1c346c2662c9dc
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> arch/x86/kvm/../../../virt/kvm/kvm_main.c:2062:25: sparse: incorrect type in assignment (different address spaces)
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:2062:25:    expected struct pid *volatile <noident>
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:2062:25:    got struct pid [noderef] <asn:4>*<noident>
>> arch/x86/kvm/../../../virt/kvm/kvm_main.c:741:9: sparse: incorrect type in assignment (different address spaces)
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:741:9:    expected struct kvm_memslots *volatile <noident>
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:741:9:    got struct kvm_memslots [noderef] <asn:4>*<noident>
   include/linux/kvm_host.h:482:16: sparse: incompatible types in comparison expression (different address spaces)
   include/linux/kvm_host.h:482:16: sparse: incompatible types in comparison expression (different address spaces)
   include/linux/kvm_host.h:482:16: sparse: incompatible types in comparison expression (different address spaces)
   include/linux/kvm_host.h:482:16: sparse: incompatible types in comparison expression (different address spaces)
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:1790:15: sparse: incompatible types in comparison expression (different address spaces)
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:2957:15: sparse: incompatible types in comparison expression (different address spaces)
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:2974:15: sparse: incompatible types in comparison expression (different address spaces)
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:3024:15: sparse: incompatible types in comparison expression (different address spaces)
--
>> arch/x86/kvm/../../../virt/kvm/irqchip.c:125:18: sparse: incorrect type in argument 1 (different address spaces)
   arch/x86/kvm/../../../virt/kvm/irqchip.c:125:18:    expected void const *<noident>
   arch/x86/kvm/../../../virt/kvm/irqchip.c:125:18:    got struct kvm_irq_routing_table [noderef] <asn:4>*irq_routing
>> arch/x86/kvm/../../../virt/kvm/irqchip.c:201:13: sparse: incorrect type in assignment (different address spaces)
   arch/x86/kvm/../../../virt/kvm/irqchip.c:201:13:    expected struct kvm_irq_routing_table *old
   arch/x86/kvm/../../../virt/kvm/irqchip.c:201:13:    got struct kvm_irq_routing_table [noderef] <asn:4>*irq_routing
--
>> arch/x86/kvm/x86.c:495:5: sparse: symbol 'kvm_read_nested_guest_page' was not declared. Should it be static?
>> arch/x86/kvm/x86.c:646:5: sparse: symbol '__kvm_set_xcr' was not declared. Should it be static?
>> arch/x86/kvm/x86.c:1183:15: sparse: symbol 'max_tsc_khz' was not declared. Should it be static?
>> arch/x86/kvm/x86.c:1237:6: sparse: symbol 'kvm_track_tsc_matching' was not declared. Should it be static?
>> arch/x86/kvm/x86.c:1898:38: sparse: incorrect type in argument 1 (different address spaces)
   arch/x86/kvm/x86.c:1898:38:    expected void const [noderef] <asn:1>*<noident>
   arch/x86/kvm/x86.c:1898:38:    got unsigned char [usertype] *
   include/linux/kvm_host.h:482:16: sparse: incompatible types in comparison expression (different address spaces)
   include/linux/kvm_host.h:482:16: sparse: incompatible types in comparison expression (different address spaces)
   arch/x86/kvm/x86.c:7431:15: sparse: incompatible types in comparison expression (different address spaces)

Please review and possibly fold the followup patch.

vim +2062 arch/x86/kvm/../../../virt/kvm/kvm_main.c

2122ff5e virt/kvm/kvm_main.c    Avi Kivity            2010-05-13  2046  		return kvm_arch_vcpu_ioctl(filp, ioctl, arg);
2122ff5e virt/kvm/kvm_main.c    Avi Kivity            2010-05-13  2047  #endif
2122ff5e virt/kvm/kvm_main.c    Avi Kivity            2010-05-13  2048  
2122ff5e virt/kvm/kvm_main.c    Avi Kivity            2010-05-13  2049  
9fc77441 virt/kvm/kvm_main.c    Michael S. Tsirkin    2012-09-16  2050  	r = vcpu_load(vcpu);
9fc77441 virt/kvm/kvm_main.c    Michael S. Tsirkin    2012-09-16  2051  	if (r)
9fc77441 virt/kvm/kvm_main.c    Michael S. Tsirkin    2012-09-16  2052  		return r;
6aa8b732 drivers/kvm/kvm_main.c Avi Kivity            2006-12-10  2053  	switch (ioctl) {
9a2bb7f4 drivers/kvm/kvm_main.c Avi Kivity            2007-02-22  2054  	case KVM_RUN:
f0fe5108 drivers/kvm/kvm_main.c Avi Kivity            2007-03-07  2055  		r = -EINVAL;
f0fe5108 drivers/kvm/kvm_main.c Avi Kivity            2007-03-07  2056  		if (arg)
f0fe5108 drivers/kvm/kvm_main.c Avi Kivity            2007-03-07  2057  			goto out;
7a72f7a1 virt/kvm/kvm_main.c    Christian Borntraeger 2014-08-05  2058  		if (unlikely(vcpu->pid != current->pids[PIDTYPE_PID].pid)) {
7a72f7a1 virt/kvm/kvm_main.c    Christian Borntraeger 2014-08-05  2059  			/* The thread running this VCPU changed. */
7a72f7a1 virt/kvm/kvm_main.c    Christian Borntraeger 2014-08-05  2060  			struct pid *oldpid = vcpu->pid;
7a72f7a1 virt/kvm/kvm_main.c    Christian Borntraeger 2014-08-05  2061  			struct pid *newpid = get_task_pid(current, PIDTYPE_PID);
7a72f7a1 virt/kvm/kvm_main.c    Christian Borntraeger 2014-08-05 @2062  			rcu_assign_pointer(vcpu->pid, newpid);
7a72f7a1 virt/kvm/kvm_main.c    Christian Borntraeger 2014-08-05  2063  			if (oldpid)
7a72f7a1 virt/kvm/kvm_main.c    Christian Borntraeger 2014-08-05  2064  				synchronize_rcu();
7a72f7a1 virt/kvm/kvm_main.c    Christian Borntraeger 2014-08-05  2065  			put_pid(oldpid);
7a72f7a1 virt/kvm/kvm_main.c    Christian Borntraeger 2014-08-05  2066  		}
b6c7a5dc drivers/kvm/kvm_main.c Hollis Blanchard      2007-11-01  2067  		r = kvm_arch_vcpu_ioctl_run(vcpu, vcpu->run);
64be5007 virt/kvm/kvm_main.c    Gleb Natapov          2010-10-24  2068  		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
6aa8b732 drivers/kvm/kvm_main.c Avi Kivity            2006-12-10  2069  		break;
6aa8b732 drivers/kvm/kvm_main.c Avi Kivity            2006-12-10  2070  	case KVM_GET_REGS: {

:::::: The code at line 2062 was first introduced by commit
:::::: 7a72f7a140bfd3a5dae73088947010bfdbcf6a40 KVM: track pid for VCPU only on KVM_RUN ioctl

:::::: TO: Christian Borntraeger <borntraeger@de.ibm.com>
:::::: CC: Paolo Bonzini <pbonzini@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
