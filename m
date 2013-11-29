Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3K2IxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:53:09 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:59052 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3K2IxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:53:06 -0500
Date: Fri, 29 Nov 2013 08:53:00 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Mark Brown'" <broonie@kernel.org>,
        "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 5/5] mfd: sec: Constify regmap configs and regmap irqs
Message-ID: <20131129085300.GC3296@lee--X1>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
 <1385626183-22990-6-git-send-email-k.kozlowski@samsung.com>
 <20131128171434.GN27568@sirena.org.uk>
 <05ce01ceec98$7b4e3470$71ea9d50$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <05ce01ceec98$7b4e3470$71ea9d50$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Nov 2013, Sangbeom Kim wrote:

> On Friday, November 29, 2013 2:15 AM, Mark Brown wrote:
> > > Add "const" to "static struct regmap_irq" and "static struct
> > > regmap_config".
> > 
> > Reviewed-by: Mark Brown <broonie@linaro.org>
> 
> Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Applied with Reviews and Acks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
