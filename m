Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934959Ab3FSRl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:41:28 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33181 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934910Ab3FSRl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:41:26 -0400
Message-ID: <51C1ED3E.3000100@redhat.com>
Date: Wed, 19 Jun 2013 19:41:18 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/7] KVM: MMU: update mmu documentation
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
In-Reply-To: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/06/2013 11:09, Xiao Guangrong ha scritto:
> As Paolo pointed out that this is the time to update the documentation, this
> patchest does it to let mmu.txt matches with the current mmu implementation
> 
> Xiao Guangrong (7):
>   KVM: MMU: update the documentation for reverse mapping of parent_pte
>   KVM: MMU: document clear_spte_count
>   KVM: MMU: document write_flooding_count
>   KVM: MMU: document mmio page fault
>   KVM: MMU: document fast page fault in
>   KVM: MMU: document fast invalidate all pages
>   KVM: MMU: document fast invalidate all mmio sptes
> 
>  Documentation/virtual/kvm/mmu.txt | 86 +++++++++++++++++++++++++++++++++++----
>  arch/x86/include/asm/kvm_host.h   | 15 +++++++
>  arch/x86/kvm/mmu.c                |  7 ++--
>  3 files changed, 97 insertions(+), 11 deletions(-)
> 

Applied all to queue since they depend on the fast MMIO-spte zap
patches.  Will graduate to next as soon as I'm finished testing those
patches.

Paolo
