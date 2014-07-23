Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbaGWGuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:50:20 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:38137 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbaGWGuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:50:18 -0400
Date: Wed, 23 Jul 2014 08:50:13 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: hskinnemoen@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avr32: Remove unnessary variables from page.h
Message-ID: <20140723065013.GA15677@samfundet.no>
References: <1406097756-7912-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406097756-7912-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 23 Jul 2014 02:42:36 -0400 or thereabout, Nicholas Krause wrote:
> This removes the unneeded variables memory_start and memory_end in
> order to fix this fix me message.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

This is already applied to my local for-linus branch, it will be pushed once
Linus opens up for merges after 3.16 is released.

> ---
>  arch/avr32/include/asm/page.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/avr32/include/asm/page.h b/arch/avr32/include/asm/page.h
> index f805d1c..701006f 100644
> --- a/arch/avr32/include/asm/page.h
> +++ b/arch/avr32/include/asm/page.h
> @@ -42,8 +42,6 @@ typedef struct page *pgtable_t;
>  #define __pgd(x)		((pgd_t) { (x) })
>  #define __pgprot(x)		((pgprot_t) { (x) })
>  
> -/* FIXME: These should be removed soon */
> -extern unsigned long memory_start, memory_end;
>  
>  /* Pure 2^n version of get_order */
>  static inline int get_order(unsigned long size)
-- 
mvh
Hans-Christian Egtvedt
