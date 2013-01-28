Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3A1Pid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:38:33 -0500
Received: from host171.canaca.com ([67.55.55.225]:43882 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3A1Pib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:38:31 -0500
Message-ID: <1b4d173a8f4cbb94f6d99ae5c75c10d5.squirrel@mungewell.org>
In-Reply-To: <alpine.LNX.2.00.1301281557040.23853@pobox.suse.cz>
References: <1359095687-13398-1-git-send-email-simon@mungewell.org>
    <alpine.LNX.2.00.1301281557040.23853@pobox.suse.cz>
Date: Mon, 28 Jan 2013 10:38:30 -0500
Subject: Re: [PATCH 1/4] USB: HID: SRW-S1 Gaming Wheel Driver
From: simon@mungewell.org
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Simon Wood" <simon@mungewell.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, rosegardener@freeode.co.uk
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 24 Jan 2013, Simon Wood wrote:
>
>> From: simon <simon@simon-virtual-machine.(none)>
>>
>> Add support the SRW-S1 by patching HID descriptor to read axis
>> as Generic Desktop X, Y and Z (rather than Usage page being
>> 'Simulation').
>>
>> Signed-off-by: Simon Wood <simon@mungewell.org>
>> tested-by: John Murphy <rosegardener@freeode.co.uk>
>
> Hi Simon,
>
> thanks for the patch.
>
>>
>> ---
>>  drivers/hid/Kconfig     |    6 +++++
>>  drivers/hid/Makefile    |    1 +
>>  drivers/hid/hid-core.c  |    1 +
>>  drivers/hid/hid-ids.h   |    3 +++
>>  drivers/hid/hid-srws1.c |   58
>> +++++++++++++++++++++++++++++++++++++++++++++++
>
> Is hid-srws1 really the best name? My understanding is that the vendor is
> called Steelseries, and we mostly stick to calling the drivers according
> to the device vendors (and grouping the quirks accordingly).
>
> So how about hid-steelseries?

I'm happy to change it; However Steelseries' other devices are all
keyboards/mice intended for/marketed at gamers. Since other Steelseries
devices are unlikely to have the same structure (OK I'm just guessing on
that) is it better to keep this driver somewhat 'seperated'?

I mean, not make life difficult trying to merge keyboard code in with this
wheel's code.... if that is required in future.

If you still would prefer a name change I can do that. In which case is
the naming of the LED interfaces still OK?

ie.
--
echo 1 > /sys/class/leds/SRWS1\:\:69005002125011007452\:\:RPM3/brightness
--

Thanks,
Simon.


