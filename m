Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaICFaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:30:08 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:56428 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaICFaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:30:06 -0400
Message-ID: <5406A760.1090306@linux.vnet.ibm.com>
Date: Wed, 03 Sep 2014 13:30:08 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 0/3] fix bugs with stale or corrupt MMIO caches
References: <1409308277-4021-1-git-send-email-pbonzini@redhat.com> <5405E550.1010201@redhat.com>
In-Reply-To: <5405E550.1010201@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090305-7014-0000-0000-0000002788F8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 11:42 PM, Paolo Bonzini wrote:
> Il 29/08/2014 12:31, Paolo Bonzini ha scritto:
>> David and Xiao, here's my take on the MMIO generation patches.  Now
>> with documentation, too. :)  Please review!
>>
>> David Matlack (2):
>>   kvm: fix potentially corrupt mmio cache
>>   kvm: x86: fix stale mmio cache bug
>>
>> Paolo Bonzini (1):
>>   KVM: do not bias the generation number in kvm_current_mmio_generation
>>
>>  Documentation/virtual/kvm/mmu.txt | 14 ++++++++++++++
>>  arch/x86/include/asm/kvm_host.h   |  1 +
>>  arch/x86/kvm/mmu.c                | 29 ++++++++++++++---------------
>>  arch/x86/kvm/x86.h                | 20 +++++++++++++++-----
>>  virt/kvm/kvm_main.c               | 30 +++++++++++++++++++++++-------
>>  5 files changed, 67 insertions(+), 27 deletions(-)
>>
> 
> Ping?

Looks good to me.

Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

