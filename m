Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbaKUNau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:30:50 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.112]:40378 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755059AbaKUNat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:30:49 -0500
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Nov 2014 08:30:49 EST
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-13.tower-194.messagelabs.com!1416576225!21210883!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.12.4; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Dmitry Lavnikevich <D.Lavnikevich@sam-solutions.com>
CC: Support Opensource <Support.Opensource@diasemi.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rtc: da9063: Fix ALARM interrupt registration.
Thread-Topic: [PATCH] rtc: da9063: Fix ALARM interrupt registration.
Thread-Index: AQHQBKgC9623rLeXOUGgGvryE55nuJxpXOmwgAAgJgCAAAuPoIABdJEAgAAUN2A=
Date: Fri, 21 Nov 2014 13:23:44 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7D0B49E1F@SW-EX-MBX02.diasemi.com>
References: <1416477273-975-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <6ED8E3B22081A4459DAC7699F3695FB7D0B4836D@SW-EX-MBX02.diasemi.com>
 <8A823154-DC33-4A5A-9B4B-8B0E3BCFE83C@sam-solutions.com>
 <6ED8E3B22081A4459DAC7699F3695FB7D0B483EE@SW-EX-MBX02.diasemi.com>
 <EFFD3D9B-9FA8-4DC6-9664-F62050232523@sam-solutions.com>
In-Reply-To: <EFFD3D9B-9FA8-4DC6-9664-F62050232523@sam-solutions.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.77]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sALDUwZX017604



On 21 November 2014 12:04 Dmitry Lavnikevich wrote: 

> > On 20Nov, 2014, at 15:43, Steve Twiss wrote:
> > On 20 November 2014 13:09 Dmitry Lavnikevich wrote:
> > [...]
> >>>
> >>> da9063-rtc da9063-rtc: Failed to request ALARM IRQ -22: -22
> >>> da9063-rtc: probe of da9063-rtc failed with error -22
> >>
> >> I have tested this patch on pfla02 board and it was ok. On which
> >> board this fail occurred?
> >
> > I am using a MCIMX6DL-SDP board -- although I the differences are in
> > my code base and not the platform in this case.
> > My apologies
> >
> > Regards,
> > Steve
> >
> > patch follows:
> [â€¦]
> 
> I see that your code also fixes the issue. And it is more consistent with
> da9055 implementation.
> So there is no need for my fix if yours is already there. Is it already accepted
> on some mainline branch?

Hi Dmitry,

No, unfortunately -- I have not had time to send it to the kernel -- it has been
in my buffer for a long time

> If not then are you going to submit it soon?

If you want to submit this, then I will support with Ack: and Tested-by:
but probably it will be quicker not to wait for me.

Regards,
Stephen

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
