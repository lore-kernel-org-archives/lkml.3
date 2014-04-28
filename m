Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbaD1Ka3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:30:29 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:39005 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbaD1KaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:30:22 -0400
Date: Mon, 28 Apr 2014 11:30:17 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH] mfd: rdc321x: Fix off-by-one for ngpio setting
Message-ID: <20140428103017.GH21279@lee--X1>
References: <1398389061.4424.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398389061.4424.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The valid gpio is GPIO0 ~ GPIO58, so ngpio should be 59.
> This patch also renames RDC321X_MAX_GPIO to RDC321X_NUM_GPIO because it
> actually means the number of available GPIOs.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/rdc321x-southbridge.c | 2 +-
>  include/linux/mfd/rdc321x.h       | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
