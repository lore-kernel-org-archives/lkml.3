Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaBNJln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:41:43 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34507 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaBNJll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:41:41 -0500
Date: Fri, 14 Feb 2014 09:41:35 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/4] mfd: stw481x: Check the return value of
 devm_regmap_init_i2c
Message-ID: <20140214094135.GM3403@lee--X1>
References: <1392196213-20576-1-git-send-email-sachin.kamat@linaro.org>
 <1392196213-20576-4-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392196213-20576-4-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> devm_regmap_init_i2c can fail. Check for it.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/stw481x.c |    6 ++++++
>  1 file changed, 6 insertions(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
