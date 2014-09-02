Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbaIBKpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:45:01 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:43814 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaIBKo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:44:59 -0400
Message-ID: <54059F20.4080509@gmail.com>
Date: Tue, 02 Sep 2014 16:12:40 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Xiubo Li <Li.Xiubo@freescale.com>, broonie@kernel.org, perex@perex.cz,
        lgirdwood@gmail.com, tiwai@suse.de, andrew@lunn.ch,
        kuninori.morimoto.gx@renesas.com, jsarha@ti.com,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/4] ASoC: simple-card: add asoc_simple_card_fmt_master()
 to simplify the code.
References: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>	<1409649969-15759-2-git-send-email-Li.Xiubo@freescale.com>	<54059A35.3020303@gmail.com> <20140902123848.78c4c62a@armhf>
In-Reply-To: <20140902123848.78c4c62a@armhf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 04:08 PM, Jean-Francois Moine wrote:
> On Tue, 02 Sep 2014 15:51:41 +0530
> Varka Bhadram <varkabhadram@gmail.com> wrote:
>
>>> +	switch (((np == bitclkmaster) << 4) | (np == framemaster)) {
>>> +	case 0x11:
>>> +		return SND_SOC_DAIFMT_CBS_CFS;
>>> +	case 0x10:
>>> +		return SND_SOC_DAIFMT_CBS_CFM;
>>> +	case 0x01:
>>> +		return SND_SOC_DAIFMT_CBM_CFS;
>>> +	default:
>>> +		return SND_SOC_DAIFMT_CBM_CFM;
>>> +	}
>>> +
>>> +	/* Shouldn't be here */
>>> +	return -EINVAL;
>>> +}
>> It will be nice if we declare the switch case numbers as macros (specific name)...
> I don't see which macros: the values are just 2 booleans.
>
I am talking about 0x11, 0x10, 0x01 values.. We can give any understandable
names to those...?


-- 
Regards,
Varka Bhadram.

