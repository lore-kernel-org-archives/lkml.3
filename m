Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbbAFKRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:17:16 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:13475 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbbAFKRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:17:12 -0500
Message-ID: <54ABB574.30602@atmel.com>
Date: Tue, 6 Jan 2015 18:14:12 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] sound: soc: atmel sam9g20_wm8731: remove useless include
References: <1420536080-29181-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1420536080-29181-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre Belloni,

On 01/06/2015 05:21 PM, Alexandre Belloni wrote:
> A mach/ header is included but never used. Simply remove it.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Thanks for your patch.

Acked-by: Bo Shen <voice.shen@atmel.com>

> ---
>   sound/soc/atmel/sam9g20_wm8731.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/sound/soc/atmel/sam9g20_wm8731.c b/sound/soc/atmel/sam9g20_wm8731.c
> index 66b66d0e7514..531728975bbb 100644
> --- a/sound/soc/atmel/sam9g20_wm8731.c
> +++ b/sound/soc/atmel/sam9g20_wm8731.c
> @@ -47,7 +47,6 @@
>   #include <sound/soc.h>
>
>   #include <asm/mach-types.h>

Btw, do you consider to remove this also?

> -#include <mach/hardware.h>
>
>   #include "../codecs/wm8731.h"
>   #include "atmel-pcm.h"
>

Best Regards,
Bo Shen
