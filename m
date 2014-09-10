Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbaIJSOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:14:19 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44657 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaIJSOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:14:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140910142740.GC16489@pengutronix.de>
References: <1410356809-26179-1-git-send-email-d.lavnikevich@sam-solutions.com>
	<1410356809-26179-3-git-send-email-d.lavnikevich@sam-solutions.com>
	<20140910142740.GC16489@pengutronix.de>
Date: Wed, 10 Sep 2014 11:14:15 -0700
Message-ID: <CAGoOwPSpkNy6uNVAjG2HgiHHscKZjL5wgVrkyGwWCmyU7x+gWg@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 2/5] ASoC: fsl: add imx-tlv320aic3x machine driver
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        shawn.guo@freescale.com, kernel@pengutronix.de, linux@arm.linux.org.uk,
        "perex@perex.cz" <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Timur Tabi <timur@tabi.org>, Xiubo Li <Li.Xiubo@freescale.com>,
        grant.likely@linaro.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 7:27 AM, Markus Pargmann <mpa@pengutronix.de> wrote:
> Hi,
>
> On Wed, Sep 10, 2014 at 04:46:46PM +0300, Dmitry Lavnikevich wrote:
>> This is driver for i.MX6 boards with tlv320aic3x audio codecs.
>>
>> Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
>> ---
>>  .../bindings/sound/fsl,imx-audio-tlv320aic3x.txt   |  27 ++++
>>  sound/soc/fsl/Kconfig                              |  13 ++
>>  sound/soc/fsl/Makefile                             |   2 +
>>  sound/soc/fsl/imx-tlv320aic3x.c                    | 177 +++++++++++++++++++++
>>  4 files changed, 219 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/sound/fsl,imx-audio-tlv320aic3x.txt
>>  create mode 100644 sound/soc/fsl/imx-tlv320aic3x.c
>
> Is it possible to use the simple-card
> (Documentation/devicetree/bindings/sound/simple-card.txt) instead of
> adding a new audio card driver? There are also DT bindings for the imx
> audiomultiplexer (imx-audmux.txt).

I don't know why my mutt doesn't display this mail.

Anyway, if Simple Card supports audmux, yes, it's also a good idea.
