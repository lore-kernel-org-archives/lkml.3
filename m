Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaHSBbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 21:31:15 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:35398 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaHSBbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 21:31:14 -0400
Date: Mon, 18 Aug 2014 18:31:10 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 0/8] mtd: nand: Support for new DT NAND driver
Message-ID: <20140819013110.GO18411@ld-irv-0074>
References: <1407921127-8590-1-git-send-email-lee.jones@linaro.org>
 <20140814224013.GE18411@ld-irv-0074>
 <20140818083953.GA4266@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818083953.GA4266@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 09:39:53AM +0100, Lee Jones wrote:
> On Thu, 14 Aug 2014, Brian Norris wrote:
> > Particularly, take a hard look at rewriting
> > include/linux/mtd/stm_nand_bbt.h.
> 
> I don't think there is any need - although this change is required:
> 
> -#if defined(MTD_NAND_STM_BBT)
> +#if defined(MTD_NAND_STM_BCH_BBT)

You're still missing a GPL header and #include guards.

Your whole patch series (both v1 and v2) also has a few legit
checkpatch.pl warnings. Please fix these.

Brian
