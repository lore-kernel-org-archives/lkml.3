Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334Ab3AQIO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 03:14:56 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:60931 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759301Ab3AQIOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 03:14:54 -0500
MIME-Version: 1.0
In-Reply-To: <1355481842-17952-2-git-send-email-jy0922.shim@samsung.com>
References: <1355481842-17952-1-git-send-email-jy0922.shim@samsung.com>
	<1355481842-17952-2-git-send-email-jy0922.shim@samsung.com>
Date: Thu, 17 Jan 2013 09:14:53 +0100
Message-ID: <CACRpkdZtiqk6WKjORFrFacd_wG7KMeCd4QedbSG3eROJ2om6FA@mail.gmail.com>
Subject: Re: [PATCH] gpio: samsung: add GPIO interrupt registration for exynos5
From: Linus Walleij <linus.walleij@linaro.org>
To: Joonyoung Shim <jy0922.shim@samsung.com>, kyungmin.park@samsung.com,
        Thomas Abraham <thomas.abraham@linaro.com>, kgene.kim@samsung.com
Cc: grant.likely@secretlab.ca, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 11:44 AM, Joonyoung Shim
<jy0922.shim@samsung.com> wrote:

> This adds GPIO interrupt registration and modification needs to register
> GPIO interrupt rightly for exynos5 SoCs. EXYNOS5_GPYx gpios shouldn't be
> counted to GPIO interrupt group register number because they doesn't
> support GPIO interrupt, so their struct samsung_gpio_cfg should be
> initialized to &samsung_gpio_cfgs[8] in declaration ahead.
>
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>

This patch has been floating for a while, Kyungmin, Kukjin, Thomas:
shall it be applied?

Yours,
Linus Walleij
