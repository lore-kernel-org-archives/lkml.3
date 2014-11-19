Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbaKSR35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:29:57 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60072 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbaKSR3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:29:55 -0500
Message-ID: <546CD38B.3050700@collabora.co.uk>
Date: Wed, 19 Nov 2014 18:29:47 +0100
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
References: <1416246184-29071-1-git-send-email-javier.martinez@collabora.co.uk>	<1416246184-29071-2-git-send-email-javier.martinez@collabora.co.uk>	<CAD=FV=Xkei_wxa3jWb8bPvuynbSyq4o=ezjVD0+e04aOPCAM+Q@mail.gmail.com>	<546C6BD2.4020802@collabora.co.uk> <CAD=FV=XpweHvcTsVTMBkv9g4+GxoO8WdngGhfVj0QnOwq3ASdQ@mail.gmail.com>
In-Reply-To: <CAD=FV=XpweHvcTsVTMBkv9g4+GxoO8WdngGhfVj0QnOwq3ASdQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On 11/19/2014 06:19 PM, Doug Anderson wrote:
>>
>> I wonder how the spidev user-space interface is supposed to be used
>> when booting with Device Trees.
> 
> OK.  Please don't take my comments as a NAK on this patch.  I should
> have done the same grep myself before sending--sorry.  I just
> remembered the old conversation and looked for that instead.
>

Ok, let's see what others say. At the very least documentation about the
spidev DT binding should be added to Documentation/devicetree/bindings/
 
> If the convention is to use "spidev" like this then I guess we're OK.
> I do wish it was a little more like "i2c" myself where you could get a
> direct access interface no matter what driver was bound underneath
> (and also if no drivers were bound underneath).  ...but I could just
> be naive.  ;)
> 

+1

> -Doug
> 

Best regards,
Javier
