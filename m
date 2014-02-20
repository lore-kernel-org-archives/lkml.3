Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaBTXfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:35:48 -0500
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:59246
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752997AbaBTXfq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:35:46 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI
 specified resources
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI
 specified resources
Thread-Index: AQHPLo6cDXgO0PHR/UiXiUkawW4KVJq+w40AgAAHCWA=
Date: Thu, 20 Feb 2014 23:35:28 +0000
Message-ID: <103ed01150444453ba4f0346b44595e2@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1392939912-7446-1-git-send-email-kys@microsoft.com>
 <20140220230606.GA20053@kroah.com>
In-Reply-To: <20140220230606.GA20053@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.192.172]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(377454003)(199002)(189002)(13464003)(24454002)(85852003)(95416001)(85306002)(2656002)(76576001)(56776001)(81816001)(92566001)(94946001)(94316002)(63696002)(77982001)(49866001)(59766001)(86612001)(80022001)(90146001)(76796001)(87936001)(76786001)(54316002)(81686001)(83072002)(74706001)(81342001)(66066001)(87266001)(93136001)(56816005)(47976001)(86362001)(4396001)(51856001)(65816001)(47736001)(54356001)(50986001)(74662001)(31966008)(76482001)(74502001)(74316001)(81542001)(47446002)(19580405001)(83322001)(19580395003)(33646001)(69226001)(53806001)(46102001)(93516002)(79102001)(74876001)(74366001)(80976001)(95666003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB596;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:131.107.192.172;FPR:B89B59B2.2EDF9C06.B3F70B68.C6E39C8.2015E;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, February 20, 2014 3:06 PM
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
> Is this for 3.14-final or 3.15?
> 
> I ask this every time, someday you will let me know ahead of time...

I am sorry Greg. This is for 3.14-final.

Regards,

K. Y
