Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaI3MEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:04:30 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:54004 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaI3ME2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:04:28 -0400
Message-ID: <542A9C41.1060706@redhat.com>
Date: Tue, 30 Sep 2014 14:04:17 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "Chen, Tiejun" <tiejun.chen@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [x86, kvm] WARNING: at arch/x86/kernel/pvclock.c:182 pvclock_init_vsyscall()
References: <20140930075927.GC9561@wfg-t540p.sh.intel.com> <542A84FD.6000702@intel.com>
In-Reply-To: <542A84FD.6000702@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/09/2014 12:25, Chen, Tiejun ha scritto:
>>
>> [    0.000000] Pid: 0, comm: swapper Not tainted
>> 3.7.0-rc3-00112-g3dc4f7c #1
> 
> Looks you're working with old kernel, so its worth trying the latest again.

That's just the commit where the bisection ended, and the first one that
introduced the problem.

Paolo
