Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaJVNyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:54:33 -0400
Received: from [65.55.169.109] ([65.55.169.109]:57997 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751694AbaJVNyb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:54:31 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Mike Surcouf <mps.surcouf.lkml@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>,
        Jeff Epler <jepler@unpythonic.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <rcochran@linutronix.de>
Subject: RE: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
 do_adjtimex()
Thread-Topic: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
 do_adjtimex()
Thread-Index: AQHP6EpL5oa00nhAzECMXNpwI49m+pw5VpSAgAADkACAAIUwkIAAF66AgABISwCAABt+4IABo8CAgAAcEICAAA+vgA==
Date: Wed, 22 Oct 2014 13:51:12 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540D6BE1@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com>
 <alpine.DEB.2.11.1410202027220.5308@nanos>
 <alpine.DEB.2.11.1410202034150.5308@nanos>
 <CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
 <20141021040212.GA6278@unpythonic.net> <20141021082058.GB6808@netboy>
 <CD2CABCB2C0A0D4682C5F8AD840141540D33BC@HKXPRD3002MB006.064d.mgd.msft.net>
 <CAL7Bo8EUcmUXhpJvrz_G-Svs+GwSF9CQec5oWWQSYBqWiJYH2w@mail.gmail.com>
 <alpine.DEB.2.11.1410221441370.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410221441370.5308@nanos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [180.154.232.47]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(199003)(13464003)(51704005)(189002)(377454003)(164054003)(24454002)(85852003)(86612001)(86146001)(2656002)(46406003)(87936001)(86362001)(84676001)(92566001)(55846006)(92726001)(50986999)(76176999)(54356999)(23726002)(19580395003)(69596002)(81156004)(50466002)(106116001)(106466001)(26826002)(16796002)(93886004)(107046002)(97756001)(85306004)(97736003)(15202345003)(31966008)(77096002)(99396003)(68736004)(4396001)(44976005)(33656002)(15975445006)(6806004)(19580405001)(95666004)(80022003)(47776003)(64706001)(21056001)(76482002)(20776003)(66066001)(46102003)(120916001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1204;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1204;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 037291602B
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB0849;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Thomas Gleixner
> Sent: Wednesday, October 22, 2014 8:42 PM
> To: Mike Surcouf
> Cc: Thomas Shao; Richard Cochran; Jeff Epler; gregkh@linuxfoundation.org;
> LKML; devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan; John Stultz; Richard Cochran
> Subject: Re: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
> do_adjtimex()
> 
> On Wed, 22 Oct 2014, Mike Surcouf wrote:
> 
> > I get that NTP can be installed locally.  This is how I regulate time
> > on my guests.  I agree the admin argument probably doesn't stand up.
> >
> > The problem is hyperv_clocksource (pluggable time source used by
> > hyperv guests) is systematically fast in my environment. by around
> > -250 PPM.
> > I get away with NTP (just).
> > However others have had to use tickadj to get hyperv_clocksource close
> > enough for NTP to work i.e. inside +/-500 PPM. (This IS outside normal
> > admin tasks)
> >
> > So if we are going to use NTP as the solution for hyperv guests (which
> > is a valid one) the systematic drift of hyperv_clocksource in
> > different environments will need to be addressed.  Maybe this patch
> > could be modified to tune the tick count on boot before NTP starts and
> > then leave it alone so NTP can take over.
> 
> How about fixing hyperv_clocksource in the first place?
> 

I've tested the hyperv_clocksource in my environment using upstream kernel. There is some minor time drift (around 1.5 second one day), it should not be that big, and break ntp. 

Mike, can you share me your kernel version and which Linux distro do you use? 

> Thanks,
> 
> 	tglx
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
