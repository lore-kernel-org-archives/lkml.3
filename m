Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbaIBPm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:42:28 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:42863 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaIBPm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:42:26 -0400
Message-ID: <5405E550.1010201@redhat.com>
Date: Tue, 02 Sep 2014 17:42:08 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 0/3] fix bugs with stale or corrupt MMIO caches
References: <1409308277-4021-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1409308277-4021-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 29/08/2014 12:31, Paolo Bonzini ha scritto:
> David and Xiao, here's my take on the MMIO generation patches.  Now
> with documentation, too. :)  Please review!
> 
> David Matlack (2):
>   kvm: fix potentially corrupt mmio cache
>   kvm: x86: fix stale mmio cache bug
> 
> Paolo Bonzini (1):
>   KVM: do not bias the generation number in kvm_current_mmio_generation
> 
>  Documentation/virtual/kvm/mmu.txt | 14 ++++++++++++++
>  arch/x86/include/asm/kvm_host.h   |  1 +
>  arch/x86/kvm/mmu.c                | 29 ++++++++++++++---------------
>  arch/x86/kvm/x86.h                | 20 +++++++++++++++-----
>  virt/kvm/kvm_main.c               | 30 +++++++++++++++++++++++-------
>  5 files changed, 67 insertions(+), 27 deletions(-)
> 

Ping?

Paolo
