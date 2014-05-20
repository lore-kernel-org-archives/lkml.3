Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaETPVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:21:02 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:57597 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbaETPU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:20:59 -0400
Date: Tue, 20 May 2014 16:20:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jay Aurabind <mail@aurabindo.in>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Trivial Monkey <trivial@rustcorp.com.au>
Subject: Re: [PATCH] mfd: abx500-core: Fix compiler warning larger stack frame
Message-ID: <20140520152054.GB24991@lee--X1>
References: <536E1543.3090107@aurabindo.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <536E1543.3090107@aurabindo.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From 95f6ac368dbe352af0dfa2097b7d58b416447be5 Mon Sep 17 00:00:00 2001
> From: Aurabindo J <mail@aurabindo.in>
> Date: Sat, 10 May 2014 15:16:58 +0530
> Subject: [PATCH] mfd: abx500-core: Fix compiler warning larger stack frame
> 
> On systems with CONFIG_FRAME_WARN=1024, compiler warns the allocation of
> an object of struct device on stack. Make the allocation dynamically to
> fix the warning.
> 
> drivers/mfd/abx500-core.c: In function ‘abx500_dump_all_banks’:
> drivers/mfd/abx500-core.c:167:1: warning: the frame size of 1032 bytes
> is larger than 1024 bytes [-Wframe-larger-than=]
> 
> Signed-off-by: Aurabindo J <mail@aurabindo.in>
> ---
>  drivers/mfd/abx500-core.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Looks good to me.  I'll apply it until Linus complains.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
