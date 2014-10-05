Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaJELUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 07:20:37 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:29990 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaJELUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 07:20:31 -0400
X-AuditID: cbfec372-b7f2f6d0000052b3-68-5431297d97bf
Date: Sun, 05 Oct 2014 08:20:23 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?0JHRg9C00Lgg0KDQvtC80LDQvdGC0L4s?= AreMa Inc 
	<info@are.ma>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, crope@iki.fi,
        mchehab@osg.samsung.com, hdegoede@redhat.com,
        laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
        sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
        peter.senna@gmail.com
Subject: Re: [PATCH 01/11] tc90522: better chip description
Message-id: <20141005082023.4d364154.m.chehab@samsung.com>
In-reply-to: <e12c8e2e2e0f84035f58d8a7848dd6f64746a0ba.1412497399.git.knightrider@are.ma>
References: <cover.1412497399.git.knightrider@are.ma>
 <e12c8e2e2e0f84035f58d8a7848dd6f64746a0ba.1412497399.git.knightrider@are.ma>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/hEN1aTcMQg2+3tC2+N79ns3i/cR6T
	xZvj05ks3q6ZxmLROXEJu8XlXXPYLHo2bGW1WP2swuL54xPsFt/edjJazPu8k8mB22PaVhWP
	nbPusnt8+BjnMbtjJqvH4a8LWTymT5Px2NIPFH6/7yqbx+dNcgGcUVw2Kak5mWWpRfp2CVwZ
	M188Ziv4zFcx9x1vA+M2ni5GTg4JAROJ3yseMkLYYhIX7q1n62Lk4hASWMIoce7vTxYIp4FJ
	Ysvu+0AZDg4WAVWJC0+lQRrYBIwkXjW2sILYIgIeEiefNbKC1DMLNDNJbD97kwUkISxgLdH2
	opEJxOYVsJL4dfkYWAOnQLTEuUNnmSAWtDBK7Fr0jxVkgYSAs8T8z9kQ9YISPybfA5vDLKAu
	MWneImYIW1viybsLrBMYBWYhKZuFpGwWkrIFjMyrGEVLi5MLipPScw31ihNzi0vz0vWS83M3
	MUKipWgH47MNVocYBTgYlXh4NX4YhAixJpYVV+YeYpTgYFYS4c3hMAwR4k1JrKxKLcqPLyrN
	SS0+xMjEwSnVwHht6euaORf/nnZylrf8dP6dKYcjU9mkk+/O6JpcNpqiuVFo75mVbQJLvf9P
	T5v28WWT0eEfUdbvH37nuiMnWzeXVaD/y777LN6XuM7ovwutT5xslW+llDqj5Ogb5YP3F20t
	YClhTri7ddvlO2/vN7ovvW5k9HxbcbNxRdK5sO1ab35IPa3KNpqkxFKckWioxVxUnAgA3qKH
	IXQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, 05 Oct 2014 17:59:37 +0900
"Буди Романто, AreMa Inc" <info@are.ma> escreveu:

> tc90522 has both satellite & terrestrial demodulators,
> thus change the category description
> 
> Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
> ---
>  drivers/media/dvb-frontends/Kconfig  | 4 ++--
>  drivers/media/dvb-frontends/Makefile | 1 +
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
> index 5a13454..0c59825 100644
> --- a/drivers/media/dvb-frontends/Kconfig
> +++ b/drivers/media/dvb-frontends/Kconfig
> @@ -621,7 +621,7 @@ config DVB_S5H1411
>  	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
>  	  to support this frontend.
>  
> -comment "ISDB-T (terrestrial) frontends"
> +comment "ISDB-S (satellite) & ISDB-T (terrestrial) frontends"
>  	depends on DVB_CORE
>  
>  config DVB_S921
> @@ -653,7 +653,7 @@ config DVB_TC90522
>  	depends on DVB_CORE && I2C
>  	default m if !MEDIA_SUBDRV_AUTOSELECT
>  	help
> -	  A Toshiba TC90522 2xISDB-T + 2xISDB-S demodulator.
> +	  Toshiba TC90522 2xISDB-S 8PSK + 2xISDB-T OFDM demodulator.
>  	  Say Y when you want to support this frontend.
>  
>  comment "Digital terrestrial only tuners/PLL"
> diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
> index ba59df6..6f05615 100644
> --- a/drivers/media/dvb-frontends/Makefile
> +++ b/drivers/media/dvb-frontends/Makefile
> @@ -116,3 +116,4 @@ obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
>  obj-$(CONFIG_DVB_AF9033) += af9033.o
>  obj-$(CONFIG_DVB_AS102_FE) += as102_fe.o
>  obj-$(CONFIG_DVB_TC90522) += tc90522.o
> +

Why to add a blank line here?

Regards,
Mauro

