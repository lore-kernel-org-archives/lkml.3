Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaI3MFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:05:17 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:64415 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaI3MFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:05:15 -0400
Message-ID: <542A9C75.4000703@redhat.com>
Date: Tue, 30 Sep 2014 14:05:09 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [x86, kvm] WARNING: at arch/x86/kernel/pvclock.c:182 pvclock_init_vsyscall()
References: <20140930075927.GC9561@wfg-t540p.sh.intel.com>
In-Reply-To: <20140930075927.GC9561@wfg-t540p.sh.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/09/2014 09:59, Fengguang Wu ha scritto:
> +--------------------------------------------------------------+------------+------------+------------+
> |                                                              | 71056ae22d | 3dc4f7cfb7 | d778df51c0 |
> +--------------------------------------------------------------+------------+------------+------------+
> | boot_successes                                               | 141        | 0          | 0          |
> | boot_failures                                                | 0          | 47         | 11         |
> | WARNING:at_arch/x86/kernel/pvclock.c:pvclock_init_vsyscall() | 0          | 47         | 11         |
> | backtrace:pvclock_init_vsyscall                              | 0          | 47         | 11         |
> | backtrace:warn_slowpath_null                                 | 0          | 47         | 11         |
> | backtrace:kvm_setup_vsyscall_timeinfo                        | 0          | 47         | 11         |
> | backtrace:kvm_guest_init                                     | 0          | 47         | 11         |
> | Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=    | 0          | 0          | 7          |
> | BUG:kernel_boot_hang                                         | 0          | 0          | 4          |
> +--------------------------------------------------------------+------------+------------+------------+

Can I get the randconfig that was used?

Paolo
