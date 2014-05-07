Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812AbaEGQBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:01:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933028AbaEGQA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:00:59 -0400
Message-ID: <536A5896.1000304@redhat.com>
Date: Wed, 07 May 2014 18:00:22 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>, mtosatti@redhat.com, hpa@zytor.com
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] KVM: x86: Fix exit handler and emulation bugs
References: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/05/2014 14:32, Nadav Amit ha scritto:
> This series of patches fixes various scenarios in which KVM does not follow x86
> specifications.  Patches #4 and #5 are related; they reflect a new revision of
> the previously submitted patch that dealt with the wrong masking of registers
> in long-mode. Patch #3 is a follow-up to the previously sumbitted patch that
> fixed the wrong reserved page table masks. Patches #3 and #5 were not tested in
> a manner that actually checks the modified behavior. Not all the pathes in
> patch #4 were tested.
>
> Thanks for reviewing the patches.
>
> Nadav Amit (5):
>   KVM: x86: Emulator does not calculate address correctly
>   KVM: vmx: handle_dr does not handle RSP correctly
>   KVM: x86: Mark bit 7 in long-mode PDPTE according to 1GB pages support
>   KVM: x86: Wrong register masking in 64-bit mode
>   KVM: x86: Fix wrong masking on relative jump/call
>
>  arch/x86/kvm/cpuid.h   |  7 +++++++
>  arch/x86/kvm/emulate.c | 47 +++++++++++++++++++++++++++++------------------
>  arch/x86/kvm/mmu.c     |  8 ++++++--
>  arch/x86/kvm/vmx.c     |  2 +-
>  4 files changed, 43 insertions(+), 21 deletions(-)
>

I'll apply patches 2 and 3.  Thanks for your work!

Paolo
