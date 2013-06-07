Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab3FGHd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:33:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50102 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3FGHd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:33:56 -0400
Message-ID: <51B18CE9.8080704@pengutronix.de>
Date: Fri, 07 Jun 2013 09:34:01 +0200
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Hector Palacios <hector.palacios@digi.com>
CC: "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "brian@crystalfontz.com" <brian@crystalfontz.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: mxsfb: DATA_FORMAT_24_BIT flag outputs invalid colours
References: <519E03B0.1080006@digi.com> <519F4435.5010703@digi.com> <201305241300.25461.jbe@pengutronix.de> <201305241533.19941.jbe@pengutronix.de> <20130607072103.GF14209@lukather> <51B18BA0.50506@digi.com>
In-Reply-To: <51B18BA0.50506@digi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5e26:aff:fe2b:7cc4
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hector,

On 07.06.2013 09:28, Hector Palacios wrote:
> On 06/07/2013 09:21 AM, maxime.ripard@free-electrons.com wrote:
>> Hi Hector,
>>
>> On Fri, May 24, 2013 at 03:33:19PM +0200, Juergen Beisert wrote:
>>> Someone told me, Qt5 cannot handle this special RGB666 mode (even not the
>>> def_rgb666_shift memory layout mentioned above). My test are based on Qt4.
>>> Qt5 needs a regular RGB888 mode, which should silently be converted
>>> internally to RGB666 in the hardware.
>>>
>>> So, your patch to always use the RGB888 memory layout seems to be the right
>>> way to go.
>>
>> Do you plan on submitting this patch? (Or did you already submit it and
>> I overlooked it?)
> 
> I wasn't sure that everybody involved agreed with the patch.
> @Juergen, would the patch break your platform?

No, we need to switch to this data format here, too.

> Additionally, the guys from Crystalfontz didn't comment on it, but their platform is 
> also using a 18bit data bus width and 32bpp.
> 
> If no-one is against I'll be glad to submit it.

You can have my Acked-by: Juergen Beisert <jbe@pengutronix.de> for this patch.

Regards,
Juergen

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | Phone: +49-5121-206917-5128 |
Peiner Str. 6-8, 31137 Hildesheim, Germany    | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686              | http://www.pengutronix.de/  |
