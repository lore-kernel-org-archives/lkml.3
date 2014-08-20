Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaHTGrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:47:15 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:52581 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaHTGrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:47:13 -0400
Date: Wed, 20 Aug 2014 07:47:08 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 0/8] mtd: nand: Support for new DT NAND driver
Message-ID: <20140820064708.GC4266@lee--X1>
References: <1407921127-8590-1-git-send-email-lee.jones@linaro.org>
 <20140814224013.GE18411@ld-irv-0074>
 <20140818083953.GA4266@lee--X1>
 <20140819013110.GO18411@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140819013110.GO18411@ld-irv-0074>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2014, Brian Norris wrote:

> On Mon, Aug 18, 2014 at 09:39:53AM +0100, Lee Jones wrote:
> > On Thu, 14 Aug 2014, Brian Norris wrote:
> > > Particularly, take a hard look at rewriting
> > > include/linux/mtd/stm_nand_bbt.h.
> > 
> > I don't think there is any need - although this change is required:
> > 
> > -#if defined(MTD_NAND_STM_BBT)
> > +#if defined(MTD_NAND_STM_BCH_BBT)
> 
> You're still missing a GPL header and #include guards.
> 
> Your whole patch series (both v1 and v2) also has a few legit
> checkpatch.pl warnings. Please fix these.

Will fix all of the above.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
