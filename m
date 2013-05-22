Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab3EVPWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 11:22:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54470 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab3EVPWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 11:22:34 -0400
Message-ID: <519CE2B7.8080704@wwwdotorg.org>
Date: Wed, 22 May 2013 09:22:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Florian Meier <florian.meier@koalo.de>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] ASoC: Add support for BCM2708
References: <519CD1CC.8070507@koalo.de>
In-Reply-To: <519CD1CC.8070507@koalo.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 08:10 AM, Florian Meier wrote:
> This driver adds support for digital audio (I2S)
> for the BCM2708 SoC that is used by the
> Raspberry Pi. External audio codecs can be
> connected to the Raspberry Pi via P5 header.
> 
> It relies on cyclic DMA engine support for BCM2708
> that is not included in this patch.

This SoC is actually the BCM2835, so the files should be named for that.

Upstream only uses device tree for BCM2835. Does this driver support DT?
Where is the DT binding definition file?

I assume you're planning on sending the DMA driver upstream too? I guess
this driver isn't useful without it.

I'll take a look at the actual patch content later.
