Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab3LCP7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:59:35 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:58102 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3LCP7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:59:33 -0500
Date: Tue, 3 Dec 2013 15:59:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mfd/pinctrl: delete platform data header
Message-ID: <20131203155926.GI28159@lee--X1>
References: <1386082249-18958-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386082249-18958-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Dec 2013, Linus Walleij wrote:

> This deletes the special AB8500 GPIO platform data passing
> header and merges the few remaining contents down into the
> abx500 pinctrl driver which handles the abx500 GPIO device.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Lee, Sam: I'd like an ACK on this one too, for the same
> reason as the previous patch.
> ---
>  drivers/pinctrl/pinctrl-abx500.c       |  1 -
>  drivers/pinctrl/pinctrl-abx500.h       | 12 ++++++++++++
>  include/linux/mfd/abx500/ab8500-gpio.h | 23 -----------------------
>  3 files changed, 12 insertions(+), 24 deletions(-)
>  delete mode 100644 include/linux/mfd/abx500/ab8500-gpio.h

Same caveat:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
