Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742AbaGYJj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:39:28 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:36059 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaGYJj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:39:26 -0400
Date: Fri, 25 Jul 2014 10:39:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] fb: backlight: add driver for iPAQ micro backlight
Message-ID: <20140725093919.GI7063@lee--X1>
References: <1406218669-2438-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406218669-2438-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014, Linus Walleij wrote:

> This adds a driver for the backlight controlled by the microcontroller
> on the Compaq iPAQ series of handheld computers: h3100, h3600
> and h3700.
> 
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v2->v3:
> - Order includes alphabetically
> - Use explicit GPL v2 license
> ChangeLog v1->v2:
> - Add a comment to clarify message format
> - Coding format and style fixes
> - Drop driver announce boilerplate
> - Drop empty remove() function
> ---
>  drivers/video/backlight/Kconfig         |  9 ++++
>  drivers/video/backlight/Makefile        |  1 +
>  drivers/video/backlight/ipaq_micro_bl.c | 83 +++++++++++++++++++++++++++++++++
>  3 files changed, 93 insertions(+)
>  create mode 100644 drivers/video/backlight/ipaq_micro_bl.c

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
