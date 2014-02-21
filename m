Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbaBUATb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:19:31 -0500
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:13890
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932087AbaBUAT1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 19:19:27 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI
 specified resources
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI
 specified resources
Thread-Index: AQHPLo6cDXgO0PHR/UiXiUkawW4KVJq+zv0AgAAH24A=
Date: Fri, 21 Feb 2014 00:19:22 +0000
Message-ID: <357c655260924e10b157020ebe47b89f@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1392939912-7446-1-git-send-email-kys@microsoft.com>
 <20140220234702.GA28682@kroah.com>
In-Reply-To: <20140220234702.GA28682@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.192.172]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(189002)(199002)(24454002)(377454003)(13464003)(51704005)(76482001)(47976001)(50986001)(74876001)(46102001)(49866001)(81342001)(95666003)(53806001)(51856001)(54356001)(59766001)(77982001)(66066001)(74706001)(54316002)(56776001)(81686001)(92566001)(80022001)(81816001)(86362001)(79102001)(47736001)(87936001)(74316001)(81542001)(2656002)(63696002)(74366001)(87266001)(80976001)(69226001)(86612001)(94946001)(83322001)(76786001)(19580395003)(19580405001)(76796001)(76576001)(74502001)(47446002)(4396001)(31966008)(94316002)(74662001)(93516002)(85306002)(83072002)(56816005)(95416001)(65816001)(33646001)(90146001)(85852003)(93136001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB595;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:131.107.192.172;FPR:D8D765BE.C1FDD26.B8DF13E3.FEEE398E.201E1;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, February 20, 2014 3:47 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI specified
> resources
> 
> On Thu, Feb 20, 2014 at 03:45:12PM -0800, K. Y. Srinivasan wrote:
> > Fix a bug in the resource walking code.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/hv/vmbus_drv.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> Fails to apply to my char-misc-next branch (if you want it in
> 3.14-final, that's where it belongs...):
> 	checking file drivers/hv/vmbus_drv.c
> 	Hunk #1 FAILED at 899.
> 	1 out of 1 hunk FAILED

Greg,

This patch is based on this commit:

commit 90f3453585479d5beb75058da46eb573ced0e6ac

    Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I just got your char-misc-next branch and it does not have the needed commit.

Regards,

K. Y
