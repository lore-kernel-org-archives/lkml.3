Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3FKMVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 08:21:08 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:5772 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307Ab3FKMVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 08:21:06 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Message-ID: <51B71608.3000302@freescale.com>
Date: Tue, 11 Jun 2013 09:20:24 -0300
From: Fabio Estevam <fabio.estevam@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oskar Schirmer <oskar@scara.com>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Zeng Zhaoming <zengzm.kernel@gmail.com>, <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] sound/sgtl5000: fix codec register initial values and
 mask
References: <1370938320-6554-1-git-send-email-oskar@scara.com>
In-Reply-To: <1370938320-6554-1-git-send-email-oskar@scara.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oskar,

On 06/11/2013 05:12 AM, Oskar Schirmer wrote:
> According to documentation bit 3:2 in register SSS_CTRL are
> reserved and zero, so initially setting the register to 0x0008
> does not make much sense. Instead, bit 4 should be marked set,
> as this is the power up default.
>
> Further, mask computation in declarative part is obviously wrong:
> Fix FRAC DIVISOR to provide an 11 bit mask correctly.
>
> Signed-off-by: Oskar Schirmer <oskar@scara.com>

Please rebase your patch against Mark Brown's topic/sgtl5000 branch:

https://git.kernel.org/cgit/linux/kernel/git/broonie/sound.git/log/?h=topic/sgtl5000

After that, you can add my:

Tested-by: Fabio Estevam <fabio.estevam@freescale.com>

