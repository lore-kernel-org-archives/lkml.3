Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbaBUBA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:00:27 -0500
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:25043
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753121AbaBUBAX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 20:00:23 -0500
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, Greg KH <gregkh@linuxfoundation.org>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI
 specified resources
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI
 specified resources
Thread-Index: AQHPLo6cDXgO0PHR/UiXiUkawW4KVJq+zv0AgAAH24CAAAvpYA==
Date: Fri, 21 Feb 2014 01:00:21 +0000
Message-ID: <3739d1ad2df8489baaf9b45207d80ad1@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1392939912-7446-1-git-send-email-kys@microsoft.com>
 <20140220234702.GA28682@kroah.com>
 <357c655260924e10b157020ebe47b89f@BY2PR03MB299.namprd03.prod.outlook.com>
In-Reply-To: <357c655260924e10b157020ebe47b89f@BY2PR03MB299.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.192.172]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(13464003)(24454002)(199002)(377454003)(189002)(87266001)(81342001)(81542001)(74876001)(80976001)(94316002)(76786001)(31966008)(51856001)(19580405001)(81686001)(83322001)(81816001)(85306002)(94946001)(86362001)(69226001)(80022001)(76796001)(15975445006)(76576001)(63696002)(46102001)(66066001)(87936001)(4396001)(1511001)(74316001)(54316002)(74502001)(47446002)(2656002)(74662001)(56776001)(54356001)(47736001)(50986001)(49866001)(74366001)(47976001)(92566001)(53806001)(59766001)(79102001)(77982001)(19580395003)(65816001)(95416001)(86612001)(93136001)(83072002)(15202345003)(93516002)(76482001)(33646001)(74706001)(85852003)(56816005)(90146001)(95666003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB300;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:131.107.192.172;FPR:D4D7CDBE.C35DD26.B8DF33E3.9EEE3982.20257;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: driverdev-devel-bounces@linuxdriverproject.org [mailto:driverdev-devel-
> bounces@linuxdriverproject.org] On Behalf Of KY Srinivasan
> Sent: Thursday, February 20, 2014 4:19 PM
> To: Greg KH
> Cc: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI specified
> resources
> 
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Thursday, February 20, 2014 3:47 PM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> > Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI specified
> > resources
> >
> > On Thu, Feb 20, 2014 at 03:45:12PM -0800, K. Y. Srinivasan wrote:
> > > Fix a bug in the resource walking code.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > ---
> > >  drivers/hv/vmbus_drv.c |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > Fails to apply to my char-misc-next branch (if you want it in
> > 3.14-final, that's where it belongs...):
> > 	checking file drivers/hv/vmbus_drv.c
> > 	Hunk #1 FAILED at 899.
> > 	1 out of 1 hunk FAILED
> 
> Greg,
> 
> This patch is based on this commit:
> 
> commit 90f3453585479d5beb75058da46eb573ced0e6ac
> 
>     Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> I just got your char-misc-next branch and it does not have the needed commit.

Greg,

The commit referenced above was checked into your char-misc.git tree on the 7th of Feb.
Can you check in this patch to the same tree. I could resend this patch.

Regards,

K. Y
> 
> Regards,
> 
> K. Y
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
