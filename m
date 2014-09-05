Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841AbaIEOXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:23:46 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:49614 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614AbaIEOXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:23:44 -0400
Date: Fri, 5 Sep 2014 16:23:30 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH] pinctrl: single: fix freudian slip
Message-ID: <20140905162330.75247029@ipc1.ka-ro>
In-Reply-To: <1409903739-25998-1-git-send-email-linus.walleij@linaro.org>
References: <1409903739-25998-1-git-send-email-linus.walleij@linaro.org>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Linus Walleij wrote:
> commit 03e9f0cac5da6af85758276cb4624caf5911f2b9
> "pinctrl: clean up after enable refactoring"
> renamed the vtable callback .enable to .set_mux. The
> renaming was done manually, and one of the alterations
> contained a freudian slip. I confess, I am human.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/pinctrl/pinctrl-single.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
> index 9032422ad18f..fb94b772ad62 100644
> --- a/drivers/pinctrl/pinctrl-single.c
> +++ b/drivers/pinctrl/pinctrl-single.c
> @@ -519,7 +519,7 @@ static const struct pinmux_ops pcs_pinmux_ops = {
>  	.get_functions_count = pcs_get_functions_count,
>  	.get_function_name = pcs_get_function_name,
>  	.get_function_groups = pcs_get_function_groups,
> -	.set_mux = pcs_sex_mux,
> +	.set_mux = pcs_set_mux,
>  	.gpio_request_enable = pcs_request_gpio,
>  };
>  
Congrats, you passed the Turing test! ;)


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
