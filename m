Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3LCOXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:23:52 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:53986 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab3LCOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:23:48 -0500
Date: Tue, 3 Dec 2013 14:23:43 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Mark Brown <mark.brown@linaro.org>
Subject: Re: [PATCH] regulator: ab8500: delete non-devicetree probe path
Message-ID: <20131203142343.GD28159@lee--X1>
References: <1386079702-22821-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386079702-22821-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Dec 2013, Linus Walleij wrote:

> The Ux500 platform has been converted to do device-tree only
> boots, no longer supports platform data passing, so this
> probe path is unused. Delete it, simplifying the driver a
> whole lot.
> 
> Cc: Mark Brown <mark.brown@linaro.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> I tried to also delete this boot path for the external regulators
> in ab8500-ext.c, but it seems to not have been cleanly converted
> to device tree yet, making it dependent on passing some platform
> data still. Thus I cannot go down the path and delete all platform
> data down to the point where (most of)
> arch/arm/mach-ux500/board-mop500-regulator.[c|h] gets deleted,
> but I can do this much.
> ---
>  drivers/regulator/ab8500.c | 102 ++++-----------------------------------------
>  1 file changed, 8 insertions(+), 94 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
