Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaBUDKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 22:10:49 -0500
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:52728
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752242AbaBUDKs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 22:10:48 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI
 specified resources
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI
 specified resources
Thread-Index: AQHPLo6cDXgO0PHR/UiXiUkawW4KVJq+zv0AgAAH24CAACM5gIAADVag
Date: Fri, 21 Feb 2014 03:10:44 +0000
Message-ID: <f5fedba08fc24fba9b499593e1735b63@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1392939912-7446-1-git-send-email-kys@microsoft.com>
 <20140220234702.GA28682@kroah.com>
 <357c655260924e10b157020ebe47b89f@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140221022113.GA28043@kroah.com>
In-Reply-To: <20140221022113.GA28043@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.19.246.69]
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(13464003)(24454002)(189002)(199002)(377454003)(76576001)(76796001)(76786001)(19580395003)(19580405001)(83322001)(69226001)(94946001)(86612001)(74502001)(85306002)(83072002)(56816005)(93516002)(85852003)(90146001)(93136001)(65816001)(95416001)(33646001)(4396001)(47446002)(74662001)(94316002)(31966008)(80022001)(81816001)(86362001)(92566001)(79102001)(47736001)(74876001)(46102001)(50986001)(47976001)(76482001)(59766001)(77982001)(54356001)(66066001)(81686001)(54316002)(74706001)(56776001)(95666003)(49866001)(81342001)(53806001)(51856001)(2656002)(63696002)(80976001)(87266001)(74366001)(87936001)(81542001)(74316001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB595;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:24.19.246.69;FPR:D8D7E5A6.8CD3DD06.40DF13E3.CEE239CE.20261;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, February 20, 2014 6:21 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI specified
> resources
> 
> On Fri, Feb 21, 2014 at 12:19:22AM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Sent: Thursday, February 20, 2014 3:47 PM
> > > To: KY Srinivasan
> > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> > > Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI
> specified
> > > resources
> > >
> > > On Thu, Feb 20, 2014 at 03:45:12PM -0800, K. Y. Srinivasan wrote:
> > > > Fix a bug in the resource walking code.
> > > >
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > ---
> > > >  drivers/hv/vmbus_drv.c |    2 ++
> > > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > >
> > > Fails to apply to my char-misc-next branch (if you want it in
> > > 3.14-final, that's where it belongs...):
> > > 	checking file drivers/hv/vmbus_drv.c
> > > 	Hunk #1 FAILED at 899.
> > > 	1 out of 1 hunk FAILED
> >
> > Greg,
> >
> > This patch is based on this commit:
> >
> > commit 90f3453585479d5beb75058da46eb573ced0e6ac
> >
> >     Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > I just got your char-misc-next branch and it does not have the needed commit.
> 
> Then I guess this isn't 3.14-final material, right?
> 
> Please resend it when you have determined which branch it should go
> into, it's out of my queue now.

Thanks Greg, I will resend the patch. Please apply it to char-misc.git tree.

Regards,

K. Y
