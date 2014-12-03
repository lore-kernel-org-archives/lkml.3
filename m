Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbaLCAGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:06:51 -0500
Received: from mail-bl2on0144.outbound.protection.outlook.com ([65.55.169.144]:22304
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932722AbaLCAGu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:06:50 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Jeff Leung <jleung@v10networks.ca>, "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] X86: Mark the Hyper-V clocksource as being continuous
Thread-Topic: [PATCH 1/1] X86: Mark the Hyper-V clocksource as being
 continuous
Thread-Index: AQHQDos/PK3eN3W9k0ulFthqgd8G05x8+ngAgAABYnA=
Date: Wed, 3 Dec 2014 00:06:46 +0000
Message-ID: <BY2PR0301MB0711D77DC4E020F9824BC9D7A07B0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1417568621-23143-1-git-send-email-kys@microsoft.com>
 <A70AC0C1B7E7FD478A6BF19705461AA01109C0@IMBER.smb.curriegrad2004.ca>
In-Reply-To: <A70AC0C1B7E7FD478A6BF19705461AA01109C0@IMBER.smb.curriegrad2004.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0711;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0711;
x-forefront-prvs: 0414DF926F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(189002)(199003)(13464003)(51704005)(50986999)(54356999)(76176999)(68736005)(15202345003)(19580395003)(19580405001)(4396001)(86612001)(95666004)(54606007)(122556002)(97736003)(120916001)(62966003)(77156002)(74316001)(76576001)(107046002)(46102003)(2501002)(33656002)(2656002)(31966008)(87936001)(20776003)(64706001)(106116001)(101416001)(106356001)(99396003)(105586002)(92726001)(92566001)(86362001)(2201001)(15975445006)(99286002)(21056001)(40100003)(54206007)(921003)(3826002)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0694;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jeff Leung [mailto:jleung@v10networks.ca]
> Sent: Tuesday, December 2, 2014 3:58 PM
> To: KY Srinivasan; x86@kernel.org; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; tglx@linutronix.de;
> hpa@zytor.com
> Cc: stable@vger.kernel.org
> Subject: RE: [PATCH 1/1] X86: Mark the Hyper-V clocksource as being
> continuous
> 
> Does this mean that host-to guest timesync now works properly with Linux
> guests?
> 
> -- Jeff

Jeff,

We have had the Hyper-V clocksource for sometime now and this patch just marks this clocksource
as being continuous. Nothing has changed with regards to timesynch.

Regards,

K. Y 

> 
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org]
> > On Behalf Of K. Y. Srinivasan
> > Sent: Tuesday, December 2, 2014 17:04
> > To: x86@kernel.org; gregkh@linuxfoundation.org;
> linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com; tglx@linutronix.de; hpa@zytor.com
> > Cc: K. Y. Srinivasan; stable@vger.kernel.org
> > Subject: [PATCH 1/1] X86: Mark the Hyper-V clocksource as being
> continuous
> >
> > The clocksource based on Hyper-V per-partition reference count MSR is
> continuous. Mark
> > it accordingly.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > cc: stable@vger.kernel.org
> > ---
> >  arch/x86/kernel/cpu/mshyperv.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/mshyperv.c
> b/arch/x86/kernel/cpu/mshyperv.c index
> > a450373..939155f 100644
> > --- a/arch/x86/kernel/cpu/mshyperv.c
> > +++ b/arch/x86/kernel/cpu/mshyperv.c
> > @@ -107,6 +107,7 @@ static struct clocksource hyperv_cs = {
> >  	.rating		= 400, /* use this when running on Hyperv*/
> >  	.read		= read_hv_clock,
> >  	.mask		= CLOCKSOURCE_MASK(64),
> > +	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
> >  };
> >
> >  static void __init ms_hyperv_init_platform(void)
> > --
> > 1.7.4.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a
> > message to majordomo@vger.kernel.org More majordomo info at
> > http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

