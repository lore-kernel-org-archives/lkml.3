Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaD1KOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:14:53 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56257 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbaD1KOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:14:50 -0400
Date: Mon, 28 Apr 2014 11:14:44 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 08/13] video/backlight: LM3630A needs PWM
Message-ID: <20140428101444.GA21279@lee--X1>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
 <1398342509-10243-9-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398342509-10243-9-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The LM3630A driver cannot be successfully built if we don't
> enable the PWM subsystem. This patch makes that dependency
> explicit in Kconfig and prevents broken randconfig builds.
> 
> Based on Arnd Bergmann patch but split out into seperate
> commits per driver based on feedback.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: linux-fbdev@vger.kernel.org
> ---
>  drivers/video/backlight/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
