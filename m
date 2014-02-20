Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaBTXqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:46:45 -0500
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:19639
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752806AbaBTXqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:46:44 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI
 specified resources
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI
 specified resources
Thread-Index: AQHPLo6cDXgO0PHR/UiXiUkawW4KVJq+zv0A////t7A=
Date: Thu, 20 Feb 2014 23:46:29 +0000
Message-ID: <a43362cb8dfc4c62934217628170751f@BY2PR03MB299.namprd03.prod.outlook.com>
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
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(189002)(199002)(377454003)(51704005)(13464003)(164054003)(24454002)(53806001)(47446002)(74366001)(54356001)(51856001)(46102001)(59766001)(54316002)(86612001)(47976001)(76576001)(76786001)(31966008)(49866001)(69226001)(74706001)(50986001)(74502001)(74662001)(86362001)(47736001)(56816005)(74316001)(77982001)(56776001)(81542001)(94316002)(87936001)(95666003)(76482001)(95416001)(80976001)(4396001)(81816001)(74876001)(76796001)(87266001)(19580405001)(92566001)(81342001)(81686001)(2656002)(79102001)(83072002)(85306002)(83322001)(19580395003)(94946001)(33646001)(93516002)(66066001)(63696002)(90146001)(85852003)(93136001)(65816001)(80022001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB597;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:131.107.192.172;FPR:D857FDBE.3ED3DD26.B3DD3FEB.FE6EF94E.20191;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
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

I will rebase it send it to you shortly.

Thanks,

K. Y
