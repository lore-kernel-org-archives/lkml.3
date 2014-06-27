Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaF0JV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:21:59 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56108 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaF0JV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:21:57 -0400
Date: Fri, 27 Jun 2014 10:21:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 02/14] mfd: max77686: Allow the max77686 rtc to wakeup
 the system
Message-ID: <20140627092149.GH19645@lee--X1>
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>
 <1403806546-31122-3-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403806546-31122-3-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014, Javier Martinez Canillas wrote:

> From: Doug Anderson <dianders@chromium.org>
> 
> The max77686 includes an RTC that keeps power during suspend.  It's
> convenient to be able to use it as a wakeup source.
> 
> NOTE: due to wakeup ordering problems this patch alone doesn't work so
> well on exynos5250-snow.  You also need something that brings the i2c
> bus up before the max77686 wakeup runs.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
> 
> Changes since v4: None
> 
> Changes since v3:
>  - Keep the note that this patch needs another change due wakeup
>    ordering problems.
> 
>  drivers/rtc/rtc-max77686.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)

This patch doesn't actually touch the MFD subsystem directly.  Can you
change the $SUBJECT line accordingly please?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
