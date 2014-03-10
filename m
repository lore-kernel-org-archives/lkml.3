Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaCJPbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:31:52 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:42374 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbaCJPbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:31:48 -0400
Date: Mon, 10 Mar 2014 15:31:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, J Keerthy <j-keerthy@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: Tree for Mar 6 (mfd/tps65218)
Message-ID: <20140310153142.GD13661@lee--X1>
References: <20140306194821.3715d0b6212cc10415374a68@canb.auug.org.au>
 <5318B2B5.4030609@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5318B2B5.4030609@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hi all,
> > 
> > There may be build failures in this tree due to the percpu changes in the
> > akpm tree.
> > 
> > This tree fails (more than usual) the powerpc allyesconfig build.
> > 
> > Changes since 20140305:
> > 
> 
> In linux-next-20140305 and -20140306:
> 
> ERROR: "regmap_del_irq_chip" [drivers/mfd/tps65218.ko] undefined!
> 
> when CONFIG_REGMAP_IRQ is not enabled.
> 
> Driver's kconfig needs to select REGMAP_IRQ ?

Fix submitted with your Reported-by. Thanks for letting us know.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
