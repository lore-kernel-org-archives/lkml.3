Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab3FRIqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:46:12 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.14]:24184 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755136Ab3FRIqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:46:09 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-8.tower-28.messagelabs.com!1371545166!24517812!1
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <51C01E46.8040506@digi.com>
Date: Tue, 18 Jun 2013 10:45:58 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>
CC: <FlorianSchandinat@gmx.de>, <linux-fbdev@vger.kernel.org>,
        Juergen Beisert <jbe@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "brian@crystalfontz.com" <brian@crystalfontz.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>, <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] video: mxsfb: fix color settings for 18bit data bus and
 32bpp
References: <519E03B0.1080006@digi.com> <519F4435.5010703@digi.com> <201305241300.25461.jbe@pengutronix.de> <201305241533.19941.jbe@pengutronix.de> <20130607072103.GF14209@lukather> <51B18BA0.50506@digi.com> <20130607074200.GG14209@lukather> <51B1957F.40104@digi.com> <20130607090228.GI14209@lukather> <20130618083229.GC15037@lukather>
In-Reply-To: <20130618083229.GC15037@lukather>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 10:32 AM, maxime.ripard@free-electrons.com wrote:
> Hi Hector,
>
> On Fri, Jun 07, 2013 at 11:02:28AM +0200, maxime.ripard@free-electrons.com wrote:
>> On Fri, Jun 07, 2013 at 10:10:39AM +0200, Hector Palacios wrote:
>>> For a combination of 18bit LCD data bus width and a color
>>> mode of 32bpp, the driver was setting the color mapping to
>>> rgb666, which is wrong, as the color in memory realy has an
>>> rgb888 layout.
>>>
>>> This patch also removes the setting of flag CTRL_DF24 that
>>> makes the driver dimiss the upper 2 bits when handling 32/24bpp
>>> colors in a diplay with 18bit data bus width. This flag made
>>> true color images display wrong in such configurations.
>>>
>>> Finally, the color mapping rgb666 has also been removed as nobody
>>> is using it and high level applications like Qt5 cannot work
>>> with it either.
>>>
>>> Reference: https://lkml.org/lkml/2013/5/23/220
>>> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
>>> Acked-by: Juergen Beisert <jbe@pengutronix.de>
>>
>> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>>
>> Please also note that fbdev is now maintained by Jean Christophe
>> Plagniol-Villard (plagnioj@jcrosoft.com, in CC), and that he is away
>> until the 10th of June, so maybe it should be safe to resend it to him
>> after this date.
>
> It seems like Jean-Christophe is back online, maybe you should resend
> him the patch now, it would be great to have it for 3.11.

I just resent it. Thanks for the reminder.

-- 
Héctor Palacios

Best regards,
--
Hector Palacios
