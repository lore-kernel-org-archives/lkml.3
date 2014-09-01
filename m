Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaIAJVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:21:46 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:38212 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbaIAJVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:21:44 -0400
Date: Mon, 1 Sep 2014 11:21:49 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm-ia64@vger.kernel.org, linux-s390@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>
Subject: Re: [PATCH 1/2] KVM: static inline empty kvm_arch functions
Message-ID: <20140901092149.GD19836@cbox>
References: <1409231583-7048-1-git-send-email-rkrcmar@redhat.com>
 <1409231583-7048-2-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409231583-7048-2-git-send-email-rkrcmar@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 03:13:02PM +0200, Radim Krčmář wrote:
> Using static inline is going to save few bytes and cycles.
> For example on powerpc, the difference is 700 B after stripping.
> (5 kB before)
> 
> This patch also deals with two overlooked empty functions:
> kvm_arch_flush_shadow was not removed from arch/mips/kvm/mips.c
>   2df72e9bc KVM: split kvm_arch_flush_shadow
> and kvm_arch_sched_in never made it into arch/ia64/kvm/kvm-ia64.c.
>   e790d9ef6 KVM: add kvm_arch_sched_in
> 
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>

For the arm/arm64 part:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
