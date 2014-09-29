Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaI2KHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 06:07:33 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:60861 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaI2KHc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:07:32 -0400
Date: Mon, 29 Sep 2014 12:07:23 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Tony Prisk <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv4 0/4] pwm: imx: support output polarity inversion
Message-ID: <20140929120723.62e7d73c@ipc1.ka-ro>
In-Reply-To: <1408517756-9412-1-git-send-email-LW@KARO-electronics.de>
References: <1408517756-9412-1-git-send-email-LW@KARO-electronics.de>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Lothar Waßmann wrote:
> This patch series adds support for polarity inversion to the pwm-imx
> driver. The patches have been tested on i.MX6, i.MX53 and with the
> ti-ehrpwm.c driver.
> 
> Changes wrt. v2:
> - make the use of '#pwm-cells = <3>' optional, so that the change does
>   not break existing DT blobs as suggested by Arnd Bergmann and Sascha
>   Hauer.
> 
> Changes wrt. v3:
> - implemented the approach suggested by Sascha Hauer 
> - don't modify struct pwm_ops in the imx_pwm probe function
> 
> 
Ping?
It's now over a month without any reaction. What should I do with these
patches?


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
