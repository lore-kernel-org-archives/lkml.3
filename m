Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3A2Hf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:35:28 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41254 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab3A2Hf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:35:26 -0500
From: "Katepallewar, Mrugesh" <mrugesh.mk@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>, "hs@denx.de" <hs@denx.de>
Subject: RE: [PATCH V2] ARM: davinci: da850: add RTC DT entries
Thread-Topic: [PATCH V2] ARM: davinci: da850: add RTC DT entries
Thread-Index: AQHN/SuhxnvZ8uKp9EiTJKKlLT2PuZheiyGAgAFdn1A=
Date: Tue, 29 Jan 2013 07:35:07 +0000
Message-ID: <4232EB8829679242B82E712C3DB3149D42355C@DBDE01.ent.ti.com>
References: <1359359268-9781-1-git-send-email-mrugesh.mk@ti.com>
 <5106A105.6030004@ti.com>
In-Reply-To: <5106A105.6030004@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0T7ZU7N006598

On Mon, Jan 28, 2013 at 21:32:13, Nori, Sekhar wrote:
> Hi Mrugesh,
> 
> On 1/28/2013 1:17 PM, Mrugesh Katepallewar wrote:
> > Add RTC DT entries in da850 dts file.
> > 
> > Signed-off-by: Mrugesh Katepallewar <mrugesh.mk@ti.com>
> > ---
> > Applies on top of v3.8-rc4 of linus tree.
> > 
> > This patch is depending on
> > "ARM: davinci: da850: add interrupt-parent property in soc node"
> > https://patchwork.kernel.org/patch/2044101/
> 
> > Tested on da850-evm device.
> > 
> > Test Procedure:
> > date 2013.01.28-10:00:00 (usage: date[YYYY.]MM.DD-hh:mm[:ss]) hwclock 
> > -w reset board and check system time.
> 
> Queuing this for v3.9. The testing information above is useful and should be part of the changelog. I moved it there while committing.
> 
> It will be nice to check the alarm functionality as well. Can you check that and let me know that works as well?

I tried to test RTC alarm using "rtcwake" command, however it is not working and returning following error 
"rtcwake: /dev/rtc0 not enabled for wakeup events"
This is coming because we have not registered RTC device as a wakeup source yet. 

For checking RTC alarm interrupt, I developed one simple program which opens RTC device, set alarm and exits.
Then by entering "cat /proc/interrupts" checked RTC interrupt count.

Using above test it confirms that RTC alarm functionality is working fine. 

> 
> Thanks,
> Sekhar
> 


Regards, 
Mrugesh
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
