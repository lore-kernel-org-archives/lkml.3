Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab3EJGzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 02:55:14 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58872 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab3EJGzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 02:55:13 -0400
Message-ID: <518C99C9.1000708@linaro.org>
Date: Fri, 10 May 2013 12:25:05 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dianders@chromium.org
Subject: Re: [PATCH] ARM: exynos: defconfig update
References: <1368133099-16997-1-git-send-email-olof@lixom.net>
In-Reply-To: <1368133099-16997-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 02:28 AM, Olof Johansson wrote:
> This turns on a number of configs that are useful on the Chromebook, but also
> good to have on in general:
> 
> * USB host and MMC drivers(!)
> * I2C GPIO arbitration driver
> * CYAPA trackpad driver
> * simplefb
> * CROS EC and keyboard drivers
> * MAX77686 drivers
> * DEVTMPFS + mount
> * DM_CRYPT (as module)
> * CRYPTOLOOP
> * HIGHMEM
> * PRINTK timestamps
> 
> This also turns off DEBUG_LL, and switches the hardcoded Samsung lowlevel
> uart to uart 3 (which is only used to show the "uncompressing kernel"
> message at boot, it seems).
> 

Setting the UART to 2, I tested this to work well with Arndale board.
Though, I would also like to enable S5M8767 driver (for Arndale board),
MAX8997 driver and MMC SDHCI driver (for Origen board). I will be
sending a patch to enable them.

> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Tested-by: Tushar Behera <tushar.behera@linaro.org>

-- 
Tushar Behera
