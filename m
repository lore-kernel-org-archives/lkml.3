Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaJUCiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 22:38:06 -0400
Received: from mail-by2on0126.outbound.protection.outlook.com ([207.46.100.126]:9311
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753835AbaJUCiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 22:38:04 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        John Stultz <john.stultz@linaro.org>
Subject: RE: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
 do_adjtimex()
Thread-Topic: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
 do_adjtimex()
Thread-Index: AQHP6EpL5oa00nhAzECMXNpwI49m+pw5VpSAgACIOoA=
Date: Tue, 21 Oct 2014 02:37:26 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540D26C3@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com>
 <alpine.DEB.2.11.1410202027220.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410202027220.5308@nanos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.4]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(377454003)(51704005)(189002)(24454002)(199003)(13464003)(46406003)(87936001)(86146001)(55846006)(106116001)(86362001)(76176999)(54356999)(66066001)(23726002)(4396001)(106466001)(81156004)(85852003)(97736003)(77096002)(92566001)(47776003)(20776003)(46102003)(107046002)(2656002)(16796002)(64706001)(31966008)(80022003)(99396003)(120916001)(76482002)(85306004)(21056001)(110136001)(50466002)(50986999)(69596002)(6806004)(19580405001)(26826002)(95666004)(92726001)(86612001)(44976005)(19580395003)(84676001)(97756001)(33656002)(68736004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR03MB283;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB283;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Tuesday, October 21, 2014 2:28 AM
> To: Thomas Shao
> Cc: gregkh@linuxfoundation.org; LKML; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com; KY Srinivasan;
> John Stultz
> Subject: Re: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
> do_adjtimex()
> 
> On Wed, 15 Oct 2014, Thomas Shao wrote:
> 
> And again you forgot to cc John Stultz on this....

I'll cc John Stultz in the future. Sorry for that.

> 
> > Export do_adjtimex function for hyper-v Time Synchronization component
> >
> > Signed-off-by: Thomas Shao <huishao@microsoft.com>
> > ---
> >  kernel/time/timekeeping.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> > index ec1791f..205a4b3 100644
> > --- a/kernel/time/timekeeping.c
> > +++ b/kernel/time/timekeeping.c
> > @@ -1786,6 +1786,7 @@ int do_adjtimex(struct timex *txc)
> >
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL_GPL(do_adjtimex);
> >
> >  #ifdef CONFIG_NTP_PPS
> >  /**
> > --
> > 1.7.1
> >
> >
