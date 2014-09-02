Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbaIBQsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:48:09 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51005 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbaIBQsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:48:07 -0400
MIME-Version: 1.0
In-Reply-To: <5405E550.1010201@redhat.com>
References: <1409308277-4021-1-git-send-email-pbonzini@redhat.com> <5405E550.1010201@redhat.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 2 Sep 2014 09:47:46 -0700
Message-ID: <CALzav=ceAVpR7kq-K2eX17s9LgC7_ddt83W8yYc_f=zN8Kh6sg@mail.gmail.com>
Subject: Re: [PATCH 0/3] fix bugs with stale or corrupt MMIO caches
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 8:42 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
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

Sorry for the delay. I think the patches look good. And patch 3/3 still
fixes the bug I was originally seeing, so I'm happy :). I just had one
small comment (see my reply to patch 2/3).

>
> Paolo
