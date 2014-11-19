Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaKSKH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:07:26 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:59518 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbaKSKHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:07:22 -0500
Message-ID: <546C6BD2.4020802@collabora.co.uk>
Date: Wed, 19 Nov 2014 11:07:14 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Simon Glass <sjg@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 1/3] ARM: dts: Add SPI flash node for Peach boards
References: <1416246184-29071-1-git-send-email-javier.martinez@collabora.co.uk>	<1416246184-29071-2-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=Xkei_wxa3jWb8bPvuynbSyq4o=ezjVD0+e04aOPCAM+Q@mail.gmail.com>
In-Reply-To: <CAD=FV=Xkei_wxa3jWb8bPvuynbSyq4o=ezjVD0+e04aOPCAM+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

Thanks for your feedback.

On 11/18/2014 06:50 PM, Doug Anderson wrote:
> This is common practice in the Chrome OS tree, but we've gotten
> pushback from upstream questioning about whether "spidev" is really a
> physical device.  See:
> 
> http://www.spinics.net/lists/linux-samsung-soc/msg29563.html
> 

I see, I thought that it was a common practice in the mainline kernel
too since I saw that many board DTS currently have a spidev node:

$ git grep 'compatible = "spidev"' arch/arm/boot/dts/ | wc -l
19

> 
> I don't really have an answer for something better to do here but I
> figured I'd at least bring up the point.
> 

I wonder how the spidev user-space interface is supposed to be used
when booting with Device Trees.

Best regards,
Javier
