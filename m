Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935486Ab3BOHex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:34:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49281 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935388Ab3BOHew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:34:52 -0500
Message-ID: <511DE4D3.8020405@ti.com>
Date: Fri, 15 Feb 2013 01:33:39 -0600
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
CC: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] ARM: OMAP4: Add OMAP4 Blaze Tablet support
References: <1360352269-14922-1-git-send-email-ruslan.bilovol@ti.com> <1360352269-14922-2-git-send-email-ruslan.bilovol@ti.com> <20130210025225.GB4801@atomide.com> <51193DE1.6080704@ti.com> <20130211190011.GS4801@atomide.com> <CAB=otbScyfU3PmANeLhgdeVEW=iG3yWXP46ZKwOWHaxeac1djA@mail.gmail.com>
In-Reply-To: <CAB=otbScyfU3PmANeLhgdeVEW=iG3yWXP46ZKwOWHaxeac1djA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.113.215]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/13/2013 05:28 PM, Ruslan Bilovol wrote:
> Hi Tony, Jon,
> 
> On Mon, Feb 11, 2013 at 9:00 PM, Tony Lindgren <tony@atomide.com> wrote:
>> * Jon Hunter <jon-hunter@ti.com> [130211 10:58]:
>>>
>>> Please note that the blaze is derived from the omap4-sdp board and so I
>>> would hope that we can use the existing for sdp dts and board file for
>>> blaze. In fact this is what I do today for basic booting.
>>>
>>> So unless there is some feature on the blaze that is not compatible with
>>> the original sdp, we should just use the sdp dts.
>>
>> Sounds like we need some common .dts file and separate files
>> for sdp, blaze and tablet that include the common .dts file?
>>
>> There's a different LCD panel at least between blaze and the
>> tablet.
> 
> Please note, that, although 'Blaze' board is very close to 'SDP' board,
> there are quite big differences comparing to 'Blaze Tablet' board.
> At least:
>  - LCD panels
>  - touchscreen controllers
>  - LEDs
>  - Keypad (on 'Blaze') / gpio keys (on 'Blaze Tablet')
>  - Sensors
>  - HS USB Host related stuff

SDP also has usb host too (but yes blaze does not).

>  - cameras (there is no embedded cameras on 'Blaze Tablet' board)
> 
> As per my point of view, next should be done:
> 1) Add the DTS file for BlazeTablet board
> 2) Figure out what is common for both and move it to some common file
> (if that makes sense)
> 
> I'm currently working on step '#1'. So after that step #2 should not
> be an issue for us.

Sounds good. They all use the same processor boards and so may be that
can be common in DT and we can have a dtsi for that.

Cheers
Jon
