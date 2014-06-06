Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaFFDAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 23:00:39 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:6879 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbaFFDAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 23:00:37 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Pavel Machek'" <pavel@ucw.cz>
CC: "'Ulf Hansson'" <ulf.hansson@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Date: Fri, 6 Jun 2014 10:59:13 +0800
Subject: RE: autosleep suspend too frquent problem
Thread-Topic: autosleep suspend too frquent problem
Thread-Index: Ac+AxTevX1Xd79C7Q7qzIu8IPMr3PwAbIoEQ
Message-ID: <35FD53F367049845BC99AC72306C23D1029A27656A3E@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D1029A27656A2D@CNBJMBX05.corpusers.net>
 <20140603120128.GA5080@amd.pavel.ucw.cz>
 <CAPDyKFqnC1u_Nhe7sJrAzBc8YktDUJC4KAKTPtYVK-Qk6mmk0A@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D1029A27656A38@CNBJMBX05.corpusers.net>
 <20140605135108.GA14162@amd.pavel.ucw.cz>
In-Reply-To: <20140605135108.GA14162@amd.pavel.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5630oBB030591

Hi  Pavel,


This is kernel log from a Android phone:

<6>[ 7262.353794] PM: suspend exit 2014-05-07 21:19:17.438320072 UTC
<6>[ 7262.353820] PM: suspend entry 2014-05-07 21:19:17.438348353 UTC
<6>[ 7264.822367] PM: suspend exit 2014-05-07 21:19:19.906892259 UTC
<6>[ 7264.822391] PM: suspend entry 2014-05-07 21:19:19.906919447 UTC
<6>[ 7266.100346] PM: suspend exit 2014-05-07 21:19:21.184872206 UTC
<6>[ 7266.100371] PM: suspend entry 2014-05-07 21:19:21.184899342 UTC
<6>[ 7268.650852] PM: suspend exit 2014-05-07 21:19:23.735377778 UTC
<6>[ 7268.650876] PM: suspend entry 2014-05-07 21:19:23.735404393 UTC
<6>[ 7269.023665] PM: suspend exit 2014-05-07 21:19:26.398622725 UTC
<6>[ 7269.023691] PM: suspend entry 2014-05-07 21:19:26.398651787 UTC
<6>[ 7269.232675] PM: suspend exit 2014-05-07 21:19:28.959217201 UTC
<6>[ 7269.250878] PM: suspend entry 2014-05-07 21:19:28.977414076 UTC
<6>[ 7269.256004] PM: suspend exit 2014-05-07 21:19:28.982547202 UTC
<6>[ 7269.260040] PM: suspend entry 2014-05-07 21:19:28.986580588 UTC
<6>[ 7269.265169] PM: suspend exit 2014-05-07 21:19:28.991711785 UTC
<6>[ 7269.269311] PM: suspend entry 2014-05-07 21:19:28.995851004 UTC
<6>[ 7270.410962] PM: suspend exit 2014-05-07 21:19:30.137503920 UTC
<6>[ 7270.410986] PM: suspend entry 2014-05-07 21:19:30.137529389 UTC
<6>[ 7272.970123] PM: suspend exit 2014-05-07 21:19:32.696662461 UTC
<6>[ 7272.973330] PM: suspend entry 2014-05-07 21:19:32.699869909 UTC
<6>[ 7275.534527] PM: suspend exit 2014-05-07 21:19:35.261069387 UTC
<6>[ 7275.534551] PM: suspend entry 2014-05-07 21:19:35.261095846 UTC
<6>[ 7275.556227] PM: suspend exit 2014-05-07 21:19:35.282769491 UTC
<6>[ 7275.579152] PM: suspend entry 2014-05-07 21:19:35.305686210 UTC
<6>[ 7275.822618] PM: suspend exit 2014-05-07 21:19:37.918187092 UTC
<6>[ 7275.822644] PM: suspend entry 2014-05-07 21:19:37.918215894 UTC
<6>[ 7276.122721] PM: suspend exit 2014-05-07 21:19:40.479243344 UTC
<6>[ 7276.122745] PM: suspend entry 2014-05-07 21:19:40.479269125 UTC
<6>[ 7278.578212] PM: suspend exit 2014-05-07 21:19:42.934733395 UTC
<6>[ 7278.578237] PM: suspend entry 2014-05-07 21:19:42.934761520 UTC

You can see there is several times suspend / resume status change 
Form 2014-05-07 21:19:28. 959217201  to 2014-05-07 21:19:28.995851004

There is also some suspend fail in this log , the suspend return -EBUSY  
Because of driver wake up system during suspend process .

During our power test , suspend frequently like this will consume more
Power , because it will suspend/resume lots of
Devices . Why don't we make a time window to make sure there is no more than
1 time suspend during the time window ?

I remember Android use wakelock for suspend in older linux kernel ,
The wakelock will make some time window check to make sure
Not suspend frequently ,  could autosleep also add this ?

Thanks



-----Original Message-----
From: Pavel Machek [mailto:pavel@ucw.cz] 
Sent: Thursday, June 05, 2014 9:51 PM
To: Wang, Yalin
Cc: 'Ulf Hansson'; linux-pm@vger.kernel.org; len.brown@intel.com; rjw@sisk.pl; linux-kernel@vger.kernel.org; linux-mmc
Subject: Re: autosleep suspend too frquent problem

On Thu 2014-06-05 14:51:41, Wang, Yalin wrote:
> Hi
> 
> Thanks for your clarification.
> 
> One problem is the sd card driver itself .
> 
> In addition, I also think kernel's autosleep.c module Have problem 
> too.
> It just test wake up count ,if the count is zero, then enter suspend.
> 
> This will result in frequent suspend / resume problems sometimes, It 
> is not acceptable, I think also need to be fixed to Avoid this special 
> scenario .

Android phones pretty much want to sleep very very often. But if you think there's coding bug in there, let us know..
								Pavel

> Thanks
> 
> 
> -----Original Message-----
> From: Ulf Hansson [mailto:ulf.hansson@linaro.org]
> Sent: Wednesday, June 04, 2014 5:53 AM
> To: Pavel Machek
> Cc: Wang, Yalin; len.brown@intel.com; rjw@sisk.pl; 
> linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; linux-mmc
> Subject: Re: autosleep suspend too frquent problem
> 
> On 3 June 2014 14:01, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >
> >> I found sd card sometimes are damaged/ destroyed On our devices .
> >> And seems it is caused by kernel's frequently suspend/resume, 
> >> Because during suspend/resume, the driver will suspend/resume 
> >> sdcard Very frequently, this will damaged the sdcard sometimes, and 
> >> the damage is not recoverable ..
> >>
> >> Sometimes kernel will enter suspend and exit suspend very 
> >> frequently, Especially when the system is in idle, but some driver 
> >> is not idle, And it will  wake up the system by irq frequently.
> >> By our power test result, if system enter suspend /resume very 
> >> frequently, Will consume more power , because it will enable 
> >> /disable many devices During a short time .
> >>
> >> I make a patch to prevent the system to enter suspend/resume state 
> >> More than one time during 2 secondsï¼š
> >
> > It is good you managed to diagnose the problem, but this si not the 
> > right solution.
> >
> > Either:
> >
> > 1) don't power down SD card during system suspend
> 
> NAK. The amount of power a card (even if there are good behaving cards as well) may utilize, in powered but idle state could be significant.
> I have seen cases of constant power consumption of several mA here.
> 
> >
> > or maybe even better
> >
> > 2) don't power _up_ SD card during system resume. Let it be powered 
> > down until the first access.
> 
> Good news! This is "almost" supported already by the mmc subsystem.
> 
> If your mmc host has set the capability flag MMC_CAP_RUNTIME_RESUME, that means the card won't be powered up (and initialized) until the next request.
> 
> However, for removable cards (!MMC_CAP_NONREMOVABLE), during system resume phase, the mmc core will trigger a "rescan" of the card, to verify it has not been removed. Thus, unfortunate for this use case, the first request (for removable cards) will be triggered during the system resume phase.
> 
> I suppose we should add some extra conditions/flags which makes the 
> mmc core to handle the above scenario. Actually I have been thinking 
> of putting together a patch for this, but it never pops up on the top 
> of my TODO list. :-)
> 
> Additionally, I wonder if this bouncing up and down from suspend to resume, could have other negative impact for other subsystems? Is it just a mmc subsystem problem? I am not so sure.
> 
> Kind regards
> Ulf Hansson
> 
> >
> > Thanks,
> >                                                                         
> > Pavel
> > --
> > (english) http://www.livejournal.com/~pavelmachek
> > (cesky, pictures)
> > http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe 
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org 
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

--
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
