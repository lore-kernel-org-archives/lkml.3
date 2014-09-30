Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaI3T0C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:26:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbaI3TZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:25:58 -0400
Date: Tue, 30 Sep 2014 16:25:35 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [x86, kvm] WARNING: at arch/x86/kernel/pvclock.c:182
 pvclock_init_vsyscall()
Message-ID: <20140930192535.GA15961@amt.cnet>
References: <20140930075927.GC9561@wfg-t540p.sh.intel.com>
 <542A9C75.4000703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542A9C75.4000703@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 02:05:09PM +0200, Paolo Bonzini wrote:
> Il 30/09/2014 09:59, Fengguang Wu ha scritto:
> > +--------------------------------------------------------------+------------+------------+------------+
> > |                                                              | 71056ae22d | 3dc4f7cfb7 | d778df51c0 |
> > +--------------------------------------------------------------+------------+------------+------------+
> > | boot_successes                                               | 141        | 0          | 0          |
> > | boot_failures                                                | 0          | 47         | 11         |
> > | WARNING:at_arch/x86/kernel/pvclock.c:pvclock_init_vsyscall() | 0          | 47         | 11         |
> > | backtrace:pvclock_init_vsyscall                              | 0          | 47         | 11         |
> > | backtrace:warn_slowpath_null                                 | 0          | 47         | 11         |
> > | backtrace:kvm_setup_vsyscall_timeinfo                        | 0          | 47         | 11         |
> > | backtrace:kvm_guest_init                                     | 0          | 47         | 11         |
> > | Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=    | 0          | 0          | 7          |
> > | BUG:kernel_boot_hang                                         | 0          | 0          | 4          |
> > +--------------------------------------------------------------+------------+------------+------------+
> 
> Can I get the randconfig that was used?
> 
> Paolo

https://lkml.org/lkml/2014/6/13/353

