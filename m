Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaJUEJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:09:45 -0400
Received: from [65.55.169.118] ([65.55.169.118]:45798 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750773AbaJUEJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:09:43 -0400
From: Thomas Shao <huishao@microsoft.com>
To: John Stultz <john.stultz@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Richard Cochran <rcochran@linutronix.de>
Subject: RE: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
 do_adjtimex()
Thread-Topic: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
 do_adjtimex()
Thread-Index: AQHP6EpL5oa00nhAzECMXNpwI49m+pw5VpSAgAADkACAAIUwkIAADR6AgAAKLbA=
Date: Tue, 21 Oct 2014 04:08:57 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540D290B@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com>
	<alpine.DEB.2.11.1410202027220.5308@nanos>
	<alpine.DEB.2.11.1410202034150.5308@nanos>
	<CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
 <CALAqxLVKZKQn628ZUa1D9ev37DUz+h4y5AXhMqCg_8dJ7JkEDw@mail.gmail.com>
In-Reply-To: <CALAqxLVKZKQn628ZUa1D9ev37DUz+h4y5AXhMqCg_8dJ7JkEDw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.4]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(199003)(24454002)(189002)(13464003)(377454003)(51704005)(85852003)(87936001)(2656002)(31966008)(99396003)(120916001)(86146001)(16796002)(68736004)(23676002)(106116001)(95666004)(107046002)(106466001)(81156004)(50466002)(77096002)(76482002)(69596002)(76176999)(50986999)(33656002)(46102003)(80022003)(93886004)(85306004)(86362001)(110136001)(64706001)(86612001)(26826002)(97736003)(92726001)(20776003)(47776003)(92566001)(15975445006)(66066001)(21056001)(4396001)(55846006)(19580405001)(19580395003)(54356999)(6806004)(44976005)(84676001)(15202345003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1202;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1202;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB0852;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9L49qVo028836



> -----Original Message-----
> From: John Stultz [mailto:john.stultz@linaro.org]
> Sent: Tuesday, October 21, 2014 11:24 AM
> To: Thomas Shao
> Cc: Thomas Gleixner; gregkh@linuxfoundation.org; LKML;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan; Richard Cochran
> Subject: Re: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
> do_adjtimex()
> 
> On Mon, Oct 20, 2014 at 8:18 PM, Thomas Shao <huishao@microsoft.com>
> wrote:
> >
> >> -----Original Message-----
> >> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> >> owner@vger.kernel.org] On Behalf Of Thomas Gleixner
> >> Sent: Tuesday, October 21, 2014 2:41 AM
> >> To: Thomas Shao
> >> Cc: gregkh@linuxfoundation.org; LKML; devel@linuxdriverproject.org;
> >> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com; KY
> >> Srinivasan; John Stultz; Richard Cochran
> >> Subject: Re: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
> >> do_adjtimex()
> >>
> >> On Mon, 20 Oct 2014, Thomas Gleixner wrote:
> >>
> >> > On Wed, 15 Oct 2014, Thomas Shao wrote:
> >> >
> >> > And again you forgot to cc John Stultz on this....
> >> >
> >> > > Export do_adjtimex function for hyper-v Time Synchronization
> >> > > component
> >>
> >> Aside of that, we really want to see the use case for this and how
> >> you addressed the problems which were pointed out by various folks.
> >>
> >
> > In some situation, the user is not able to enable guest VM to sync
> > with external time source, like NTP. But the host is still synced with a
> trusted time source.
> > In this case, host-guest time synchronization is useful. Hyper-v host
> > will send time sample to guest VM every 5 seconds. We will use these
> > time samples to adjust guest VM time.
> >
> > I've got some feedbacks from Richard and Mike, including reference NTP
> > implementation and do the adjustment in the host side. I've already
> > referenced some NTP design in my patch. I would consider my patch as a
> > simplified implementation. I've also considered the host side
> > implementation. But in host, we can only set time but not gradually
> > slew/adjust time, which is not acceptable for the time sync
> > solution.We still recommend user to configure NTP on the guest, which
> provides better accuracy. But if NTP is not applicable, this could be another
> option.
> >
> >> I still do not have a consistent argument from you WHY you need to
> >> abuse
> >> do_adjtimex() to do that host - guest synchronization in the first place.
> >>
> >
> > I need a function to gradually slew guest time. do_adjtimex() provides
> > all the functionality. Also I could not find any other exposed func to
> > do this. I'd like to hear any feedback from you for this.
> 
> Do you have any protections from both your kernel module trying to slew
> time if the guest is also running NTPd? That seems like it could cause some
> strange behavior.

Thanks John.
I didn't find a way to detect whether NTPd is running in the hyper-v module.  

In http://doc.ntp.org/4.1.0/ntpd.htm, it mentioned: Normally, the time is slewed
 if the offset is less than the step threshold, which is 128 ms by default, and 
stepped if above the threshold.

In my implementation, I use 100ms as the threshold (maybe I should change to 128?).
If the time difference is less than 100ms, I just do nothing. So, if NTPd is running, ideally it 
could keep the time drift less than 128, so the adjustment in my patch will not get 
triggered. 

And moreover, by default, the guest-host time sync is turn off. There is a module parameter
to control it. We'll also document customer that do not turn on this if NTP is configured.

> 
> thanks
> -john
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
