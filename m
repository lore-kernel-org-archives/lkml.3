Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3GSVw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:52:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37689 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab3GSVw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:52:57 -0400
Date: Fri, 19 Jul 2013 22:49:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linus.walleij@stericsson.com,
        arnd@arndb.de, srinidhi.kasagar@stericsson.com,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 10/22] ARM: ux500: Remove '0x's from Exynos5420 DTS file
Message-ID: <20130719214907.GI24642@n2100.arm.linux.org.uk>
References: <1374242333-6852-1-git-send-email-lee.jones@linaro.org> <1374242333-6852-10-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374242333-6852-10-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 02:58:41PM +0100, Lee Jones wrote:
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: linux-samsung-soc@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/exynos5420.dtsi | 2 +-

One question.  What have all these files got to do with ux500 ?
