Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab3KMLjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:39:18 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40089 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab3KMLjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:39:16 -0500
Date: Wed, 13 Nov 2013 11:39:10 +0000
From: Lee Jones <lee.jones@linaro.org>
To: micky <micky_ching@realsil.com.cn>
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        wei_wang@realsil.com.cn, rogerable@realtek.com
Subject: Re: [PATCH] mfd: rtsx: add card reader rtl8402
Message-ID: <20131113113910.GC3863@lee--X1>
References: <1383295053-21061-1-git-send-email-micky_ching@realsil.com.cn>
 <20131108095641.GU30901@lee--X1>
 <5282D636.60609@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5282D636.60609@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm trying to merge the common code into a single function
> rtl8411_init_params(), but different chips may use a different
> rtlxxx_pcr_ops even they have much the same.  This is because the
> ops may be called frequently.

So to save confusion I've sent a patch-set with you CC'ed.

If you can test the patchset on your h/w and add your Tested-by: tag I
will add it to each of the patches.

With regards to the 'mfd: rtsx: Add rtl8402 card reader' patch, I
believe you are the rightful author of that patch, so if you can send
me your Signed-off-by: for that one, I will add that and make you the
author.

> Yet I'm trying to use Regulator Framework, it will make a
> somewhat big change , and I will add it in a later time.

Yes that's fine. Base any new patches on top of this patch-set.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog 
