Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaBNJlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:41:06 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:47294 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaBNJlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:41:04 -0500
Date: Fri, 14 Feb 2014 09:40:57 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3/4] mfd: stw481x: Staticize stw481x_regmap_config
Message-ID: <20140214094057.GL3403@lee--X1>
References: <1392196213-20576-1-git-send-email-sachin.kamat@linaro.org>
 <1392196213-20576-3-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392196213-20576-3-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014, Sachin Kamat wrote:

> stw481x_regmap_config is local to this file.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/stw481x.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied with Linus' Ack.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
