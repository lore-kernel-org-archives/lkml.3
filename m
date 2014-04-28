Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaD1Jy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:54:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:4799 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaD1Jy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:54:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,943,1389772800"; 
   d="scan'208";a="424799183"
Message-ID: <535E254A.4020500@intel.com>
Date: Mon, 28 Apr 2014 17:54:18 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [KVM] BUG: unable to handle kernel NULL pointer dereference at
 00000000000002b0
References: <534B930A.4070507@intel.com> <535E2054.8050805@redhat.com>
In-Reply-To: <535E2054.8050805@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 05:33 PM, Paolo Bonzini wrote:
> Il 14/04/2014 09:49, Jet Chen ha scritto:
>> Hi Paolo,
>>
>> We noticed the below kernel BUG on
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> 
> What commit?
> 

This one,

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

commit 93c4adc7afedf9b0ec190066d45b6d67db5270da
Author:     Paolo Bonzini <pbonzini@redhat.com>
AuthorDate: Wed Mar 5 23:19:52 2014 +0100
Commit:     Paolo Bonzini <pbonzini@redhat.com>
CommitDate: Mon Mar 17 12:21:39 2014 +0100

      KVM: x86: handle missing MPX in nested virtualization


BTW, the same issue has been reported by Fengguang last month.

https://lkml.org/lkml/2014/3/26/200

Thanks,
Jet

> Paolo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
