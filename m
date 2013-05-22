Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab3EVQIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:08:30 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:46963 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab3EVQI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:08:28 -0400
Message-ID: <519CED72.40406@koalo.de>
Date: Wed, 22 May 2013 18:08:18 +0200
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] ASoC: Add support for BCM2708
References: <519CD1CC.8070507@koalo.de> <519CE2B7.8080704@wwwdotorg.org>
In-Reply-To: <519CE2B7.8080704@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.05.2013 17:22, Stephen Warren wrote:
> On 05/22/2013 08:10 AM, Florian Meier wrote:
>> This driver adds support for digital audio (I2S)
>> for the BCM2708 SoC that is used by the
>> Raspberry Pi. External audio codecs can be
>> connected to the Raspberry Pi via P5 header.
>>
>> It relies on cyclic DMA engine support for BCM2708
>> that is not included in this patch.
> 
> This SoC is actually the BCM2835, so the files should be named for that.

Actually, I changed the name several times and in the end I sticked to
https://github.com/raspberrypi/linux/issues/22
but if you think it is better to use BCM2835 I am happy to agree with
you and change it.

> Upstream only uses device tree for BCM2835. Does this driver support DT?
> Where is the DT binding definition file?

I have not accomplished to use the mainline kernel and DT with the
Raspberry Pi. Do you have any introductive information about how to do this?

> I assume you're planning on sending the DMA driver upstream too? I guess
> this driver isn't useful without it.

I would like to, but it only supports cyclic DMA. Should I send it
upstream anyway? In case you are interested:

https://github.com/koalo/linux/blob/rpi-3.8.y-asocdev/drivers/dma/bcm2708-dmaengine.c

> I'll take a look at the actual patch content later.

That would be great!


