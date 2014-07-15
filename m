Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbaGOTCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:02:23 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:38782 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932734AbaGOTCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:02:19 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2014 15:02:19 EDT
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: rth@twiddle.net, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] alpha: Join lines 90 and 91
References: <1405448304-3724-1-git-send-email-xerofoify@gmail.com>
	<1405448304-3724-6-git-send-email-xerofoify@gmail.com>
Date: Tue, 15 Jul 2014 19:54:59 +0100
In-Reply-To: <1405448304-3724-6-git-send-email-xerofoify@gmail.com> (Nicholas
	Krause's message of "Tue, 15 Jul 2014 14:18:24 -0400")
Message-ID: <yw1xzjgaa1vg.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas Krause <xerofoify@gmail.com> writes:

> This fixes the checkpatch error I get in this file relating to a
> quoted string needed to be joined to the line above it.
> ---
>  arch/alpha/boot/bootpz.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/alpha/boot/bootpz.c b/arch/alpha/boot/bootpz.c
> index 6fc840d..a9e127b 100644
> --- a/arch/alpha/boot/bootpz.c
> +++ b/arch/alpha/boot/bootpz.c
> @@ -87,8 +87,7 @@ check_range(unsigned long vstart, unsigned long vend,
>  		kaddr = (find_pa(vaddr) | PAGE_OFFSET);
>  		if (kaddr >= kstart && kaddr <= kend) {
>  #ifdef DEBUG_CHECK_RANGE
> -			srm_printk("OVERLAP: vaddr 0x%lx kaddr 0x%lx"
> -				   " [0x%lx:0x%lx]\n",
> +			srm_printk("OVERLAP: vaddr 0x%lx kaddr 0x%lx" " [0x%lx:0x%lx]\n",
>  				   vaddr, kaddr, kstart, kend);
>  #endif

If you're doing this, you should merge the strings too.

-- 
Måns Rullgård
mans@mansr.com
