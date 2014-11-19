Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbaKSR7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:59:44 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60112 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388AbaKSR7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:59:42 -0500
Message-ID: <546CDA83.5060002@collabora.co.uk>
Date: Wed, 19 Nov 2014 18:59:31 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Doug Anderson <dianders@chromium.org>
CC: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Simon Glass <sjg@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] ARM: dts: Add SPI flash node for Peach boards
References: <1416246184-29071-1-git-send-email-javier.martinez@collabora.co.uk> <1416246184-29071-2-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=Xkei_wxa3jWb8bPvuynbSyq4o=ezjVD0+e04aOPCAM+Q@mail.gmail.com> <546C6BD2.4020802@collabora.co.uk> <CAD=FV=XpweHvcTsVTMBkv9g4+GxoO8WdngGhfVj0QnOwq3ASdQ@mail.gmail.com> <20141119174709.GF22111@sirena.org.uk>
In-Reply-To: <20141119174709.GF22111@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 11/19/2014 06:47 PM, Mark Brown wrote:
> These are bugs.  The device tree should describe the hardware, spidev is
> a Linux implementation detail.  Provide a compatible string for the
> device that is there just as you would for any other device.
>

Thanks a lot for your explanation.
 
>> OK.  Please don't take my comments as a NAK on this patch.  I should
>> have done the same grep myself before sending--sorry.  I just
>> remembered the old conversation and looked for that instead.
> 
> Please take this as one.
> 

Ok

Best regards,
Javier
