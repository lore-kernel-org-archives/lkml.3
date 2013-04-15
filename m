Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715Ab3DOMmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 08:42:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63648 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab3DOMmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 08:42:33 -0400
X-AuditID: cbfee61b-b7f076d0000034b6-84-516bf5b83ef1
From: Tomasz Figa <t.figa@samsung.com>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
        lrg@ti.com, m.szyprowski@samsung.com, kgene.kim@samsung.com
Subject: Re: [PATCH 0/3] regulator: max8998: Add support for Device Tree
Date: Mon, 15 Apr 2013 14:42:08 +0200
Message-id: <1884769.9OL2jLgc2r@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.1 (Linux/3.8.3-gentoo-r1; KDE/4.10.1; x86_64; ; )
In-reply-to: <1365092363-12763-1-git-send-email-t.figa@samsung.com>
References: <1365092363-12763-1-git-send-email-t.figa@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t9jQd0dX7MDDSZu47L4N/sUm8WB2Q9Z
	LXoXXGWzONv0ht3i8q45bBYzzu9jsmjaPoHdYu2Ru+wOHB7nZyxk9Hg58TebR9+WVYwex29s
	Z/L4vEkugDWKyyYlNSezLLVI3y6BK+P0nb1MBbN4K9o2H2VrYNzI2cXIySEhYCLR+2sfK4Qt
	JnHh3nq2LkYuDiGB6YwSb25cBUsICbQwSZyfrQpiswmoSXxueARUxMEhIqAusfW4DkiYWeAI
	o8SNFh+QsLCAh8Sl944gYRYBVYnfZ68wgti8ApoST15dYwGx+YE63217ygRiiwKVf3vxhx2k
	lVPAWeLQZG2IpU4Szz7fhmoVlPgx+R4LxCZ5iX37p7JC2FoS63ceZ5rAKDgLSdksJGWzkJQt
	YGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcAc+kdzCuarA4xCjAwajEwztBOztQiDWx
	rLgy9xCjBAezkgjvk6NAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTSE0tSs1NTC1KL
	YLJMHJxSDYzSnJ/WHj/HIzS7yWP9BfH8moOWW4LvsLqpmdyazaP+Mos5zzTUbLcrl13zq/ia
	P2fl/wcV7A3znqO7IeHFmR897W3PXlcdLt8k87vQPV3lgc0CyYwPbhVaLjq3ROWOrLKZabrn
	omjuApnsQ62WuWIM+xqm7Ms7JDEx7r26b1eYoaS67v5OPSWW4oxEQy3mouJEAIXFyz58AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thursday 04 of April 2013 18:19:20 Tomasz Figa wrote:
> This series adds Device Tree support to max8998 MFD driver.
> 
> First patch reworks max8998-irq driver to use IRQ domains. Second patch
> prepares platform data structure to ease generating it at runtime from
> data parsed from device tree. Third patch implements Device Tree
> binding and adds necessary documentation.
> 
> Tested on Universal C210 board.
> 
> Tomasz Figa (3):
>   mfd: Add irq domain support for max8998 interrupts
>   regulator: max8998: Use arrays for specifying voltages in platform
>     data
>   mfd: max8998: Add support for Device Tree
> 
>  Documentation/devicetree/bindings/mfd/max8998.txt | 111 ++++++++++
>  arch/arm/mach-exynos/mach-universal_c210.c        |   8 +-
>  arch/arm/mach-s5pv210/mach-aquila.c               |   8 +-
>  arch/arm/mach-s5pv210/mach-goni.c                 |   8 +-
>  drivers/mfd/Kconfig                               |   1 +
>  drivers/mfd/max8998-irq.c                         |  61 +++---
>  drivers/mfd/max8998.c                             |  76 ++++++-
>  drivers/regulator/max8998.c                       | 254
> ++++++++++++++++------ drivers/rtc/rtc-max8998.c                         | 
> 17 +-
>  include/linux/mfd/max8998-private.h               |   6 +-
>  include/linux/mfd/max8998.h                       |  20 +-
>  11 files changed, 435 insertions(+), 135 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/max8998.txt

Any chance to still have this series merged for 3.10?

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center
SW Solution Development, Kernel and System Framework

