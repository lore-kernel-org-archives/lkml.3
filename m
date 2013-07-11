Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab3GKJEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 05:04:34 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.208]:60204 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755838Ab3GKJEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 05:04:33 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jul 2013 05:04:33 EDT
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-7.tower-45.messagelabs.com!1373533069!32193798!1
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <51DE734A.80206@digi.com>
Date: Thu, 11 Jul 2013 10:56:42 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        Marek Vasut <marex@denx.de>, "cb@sgoc.de" <cb@sgoc.de>
Subject: Re: MXS persistent bits driver
References: <51DE5F1A.8010209@digi.com> <20130711082413.GU11243@lukather>
In-Reply-To: <20130711082413.GU11243@lukather>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Maxime,

On 07/11/2013 10:24 AM, maxime.ripard@free-electrons.com wrote:
> Hi Hector,
>
> On Thu, Jul 11, 2013 at 09:30:34AM +0200, Hector Palacios wrote:
>> Greetings,
>>
>> Linux 2.6.35 had a driver for sysfs access to the MXS persistent
>> bits (drivers/misc/mxs-persistent.c).
>
> Freescale's 2.6.35 I suspect, right?

Yes.

>> I haven't seen this is supported upstream. Is anybody working on that?
>> Where would such a driver fit?
>
> Christoph Baumann recently started porting the Freescale's driver to
> newer release.
>
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/181569.html
>
> This needs quite a lot of work, but it's ongoing.
>
> Also, about where to put such a driver, I started a discussion about
> this last week. Mostly, that would be part of MTD, from what is out of
> the discussion so far.
>
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/182002.html

I was talking about RTC persistent bits, not OTP bits, but I they also fit in your 
EEPROM like model. I like it!

Best regards,
--
Hector Palacios
