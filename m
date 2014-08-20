Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315AbaHTGsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:48:20 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:46375 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaHTGsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:48:18 -0400
Date: Wed, 20 Aug 2014 07:48:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 0/8] mtd: nand: Support for new DT NAND driver
Message-ID: <20140820064813.GD4266@lee--X1>
References: <1407921127-8590-1-git-send-email-lee.jones@linaro.org>
 <20140814224013.GE18411@ld-irv-0074>
 <20140818083953.GA4266@lee--X1>
 <20140819190653.GV18411@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140819190653.GV18411@ld-irv-0074>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2014, Brian Norris wrote:

> On Mon, Aug 18, 2014 at 09:39:53AM +0100, Lee Jones wrote:
> > On Thu, 14 Aug 2014, Brian Norris wrote:
> > > drivers/mtd/nand/stm_nand_bch.c: In function 'bch_calc_timing_registers':
> > > drivers/mtd/nand/stm_nand_bch.c:1022:6: warning: variable 'ren_half_off' set but not used [-Wunused-but-set-variable]
> > > drivers/mtd/nand/stm_nand_bch.c:1021:6: warning: variable 'ren_half_on' set but not used [-Wunused-but-set-variable]
> > 
> > This I have never seen.  I guess -Wunused-but-set-variable is normally
> > off.  This issue has been present since the beginning of this endeavour
> > and exists in the original (internal) code.
> 
> BTW, you can get extra warnings by building with the W=[123] option to
> the Makefile (e.g., 'make W=1').
> 
> $ make help
> [...]
>   make W=n   [targets] Enable extra gcc checks, n=1,2,3 where
> 		1: warnings which may be relevant and do not occur too often
> 		2: warnings which occur quite often but may still be relevant
> 		3: more obscure warnings, can most likely be ignored
> 		Multiple levels can be combined with W=12 or W=123

Already taken care of.

I will reply in more detail to your other (build warnings) email.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
