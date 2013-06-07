Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab3FGH3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:29:20 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.14]:39190 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023Ab3FGH3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:29:19 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-16.tower-28.messagelabs.com!1370590125!29310631!1
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <51B18BA0.50506@digi.com>
Date: Fri, 7 Jun 2013 09:28:32 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>
CC: Juergen Beisert <jbe@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "brian@crystalfontz.com" <brian@crystalfontz.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: mxsfb: DATA_FORMAT_24_BIT flag outputs invalid colours
References: <519E03B0.1080006@digi.com> <519F4435.5010703@digi.com> <201305241300.25461.jbe@pengutronix.de> <201305241533.19941.jbe@pengutronix.de> <20130607072103.GF14209@lukather>
In-Reply-To: <20130607072103.GF14209@lukather>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

On 06/07/2013 09:21 AM, maxime.ripard@free-electrons.com wrote:
> Hi Hector,
>
> On Fri, May 24, 2013 at 03:33:19PM +0200, Juergen Beisert wrote:
>> Someone told me, Qt5 cannot handle this special RGB666 mode (even not the
>> def_rgb666_shift memory layout mentioned above). My test are based on Qt4.
>> Qt5 needs a regular RGB888 mode, which should silently be converted
>> internally to RGB666 in the hardware.
>>
>> So, your patch to always use the RGB888 memory layout seems to be the right
>> way to go.
>
> Do you plan on submitting this patch? (Or did you already submit it and
> I overlooked it?)

I wasn't sure that everybody involved agreed with the patch.
@Juergen, would the patch break your platform?
Additionally, the guys from Crystalfontz didn't comment on it, but their platform is 
also using a 18bit data bus width and 32bpp.

If no-one is against I'll be glad to submit it.

Best regards,
--
Hector Palacios
