Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbaJ2Jra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:47:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:55238 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbaJ2Jr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:47:28 -0400
Date: Wed, 29 Oct 2014 10:47:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Minfei Huang <mnfhuang@gmail.com>
cc: mingo@redhat.com, hpa@zytor.com, pbonzini@redhat.com,
        akpm@linux-foundation.org, bp@suse.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm: Re-use the early_ioremap fixed area
In-Reply-To: <1414563151-7175-1-git-send-email-mnfhuang@gmail.com>
Message-ID: <alpine.DEB.2.11.1410291045520.5308@nanos>
References: <1414563151-7175-1-git-send-email-mnfhuang@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Minfei Huang wrote:
> diff --git a/arch/x86/include/asm/highmem.h b/arch/x86/include/asm/highmem.h
> index 302a323..49b7469 100644
> --- a/arch/x86/include/asm/highmem.h
> +++ b/arch/x86/include/asm/highmem.h
> @@ -41,9 +41,7 @@ extern unsigned long highstart_pfn, highend_pfn;
>   * FIXADDR_TOP
>   * 			fixed_addresses
>   * FIXADDR_START
> - * 			temp fixed addresses
> - * FIXADDR_BOOT_START

We should at least add a comment here which makes it clear, that
PKMAP/VMALLOC area is used for early_ioremap() during early boot.

Thanks,

	tglx
