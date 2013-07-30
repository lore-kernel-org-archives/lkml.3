Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab3G3LyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:54:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42565 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3G3LyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:54:06 -0400
Date: Tue, 30 Jul 2013 13:54:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH 01/22] ARM: ux500: Remove '0x's from HREF v60+ DTS file
Message-ID: <20130730115403.GA29992@amd.pavel.ucw.cz>
References: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2013-07-19 14:58:32, Lee Jones wrote:
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Why?

									Pavel

> diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
> index 3d580d6..46fd8af 100644
> --- a/arch/arm/boot/dts/hrefv60plus.dts
> +++ b/arch/arm/boot/dts/hrefv60plus.dts
> @@ -26,7 +26,7 @@
>  
>  	soc {
>  		i2c@80110000 {
> -			bu21013_tp@0x5c {
> +			bu21013_tp@5c {
>  				reset-gpio = <&gpio4 15 0x4>;
>  			};
>  		};

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
