Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab3FCOQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:16:31 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:36145
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755177Ab3FCOQ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:16:28 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zz98dI9371I154dI542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Jiri Kosina <jkosina@suse.cz>, Thomas Meyer <thomas@m3y3r.de>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] HID: hyperv: Cocci spatch "memdup.spatch"
Thread-Topic: [PATCH] HID: hyperv: Cocci spatch "memdup.spatch"
Thread-Index: AQHOXqxHPTIDgUkoikOFQGfKwqNoSpkj31AAgAAseRA=
Date: Mon, 3 Jun 2013 14:14:09 +0000
Message-ID: <e91f5ef1d111418e8383867c3d0c81eb@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1370079631.29224.9.camel@localhost.localdomain>
 <alpine.LNX.2.00.1306031334040.6750@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1306031334040.6750@pobox.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.56.200.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.CZ$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%M3Y3R.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704005)(54534003)(24454002)(199002)(13464003)(377454002)(189002)(51856001)(50466002)(47446002)(74502001)(66066001)(63696002)(74876001)(49866001)(74706001)(65816001)(76796001)(53806001)(46102001)(54356001)(47776003)(69226001)(23726002)(74662001)(20776003)(31966008)(76786001)(6806003)(56816002)(33646001)(80022001)(76576001)(81342001)(54316002)(47736001)(44976003)(16676001)(56776001)(59766001)(77982001)(46406003)(74366001)(79102001)(47976001)(50986001)(76482001)(81542001)(4396001)(74316001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB018;H:TK5EX14MLTC104.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 08660C8631
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jiri Kosina [mailto:jkosina@suse.cz]
> Sent: Monday, June 03, 2013 7:35 AM
> To: Thomas Meyer
> Cc: KY Srinivasan; Haiyang Zhang; devel@linuxdriverproject.org; linux-
> input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] HID: hyperv: Cocci spatch "memdup.spatch"
> 
> On Sat, 1 Jun 2013, Thomas Meyer wrote:
> 
> > Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> > ---
> >
> > diff -u -p a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
> > --- a/drivers/hid/hid-hyperv.c
> > +++ b/drivers/hid/hid-hyperv.c
> > @@ -199,13 +199,11 @@ static void mousevsc_on_receive_device_i
> >  	if (desc->bLength == 0)
> >  		goto cleanup;
> >
> > -	input_device->hid_desc = kzalloc(desc->bLength, GFP_ATOMIC);
> > +	input_device->hid_desc = kmemdup(desc, desc->bLength,
> GFP_ATOMIC);
> >
> >  	if (!input_device->hid_desc)
> >  		goto cleanup;
> >
> > -	memcpy(input_device->hid_desc, desc, desc->bLength);
> > -
> >  	input_device->report_desc_size = desc->desc[0].wDescriptorLength;
> >  	if (input_device->report_desc_size == 0) {
> >  		input_device->dev_info_status = -EINVAL;
> >
> 
> I guess you are going to get some pushback from some maintainers due to
> non-descriptive subject and missing changelog :)
> 
> I have fixed this for the hyperv patch and applied it, thanks.

Thanks Jiri!

K. Y
> 
> --
> Jiri Kosina
> SUSE Labs
> 


