Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3FQNdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:33:33 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:25589
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751533Ab3FQNda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:33:30 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V3 0/5] Drivers: scsi: storvsc 
Thread-Topic: [PATCH V3 0/5] Drivers: scsi: storvsc 
Thread-Index: AQHOYVGHFQKsoHbYTUC6J/U9G4VqfJkwhKbwgAl2n3A=
Date: Mon, 17 Jun 2013 13:32:05 +0000
Message-ID: <f418fbf7122a489395ffb05dd0e1f792@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1370372674-10046-1-git-send-email-kys@microsoft.com>
 <ba5d1c4a36a441f09e6a1c5aa4e6d6a3@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <ba5d1c4a36a441f09e6a1c5aa4e6d6a3@SN2PR03MB061.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%PARALLELS.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%INFRADEAD.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(51704005)(13464003)(189002)(377454002)(53806001)(74316001)(44976003)(46102001)(80022001)(23726002)(74366001)(4396001)(46406003)(77982001)(50466002)(74502001)(81342001)(79102001)(76482001)(74662001)(54316002)(51856001)(54356001)(16676001)(81542001)(31966008)(47446002)(74876001)(59766001)(69226001)(33646001)(47776003)(66066001)(6806003)(50986001)(56816003)(47736001)(74706001)(65816001)(63696002)(77096001)(76786001)(76576001)(56776001)(76796001)(20776003)(47976001)(49866001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB033;H:TK5EX14MLTC103.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0880FB6EC1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: KY Srinivasan
> Sent: Tuesday, June 11, 2013 9:02 AM
> To: KY Srinivasan; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: RE: [PATCH V3 0/5] Drivers: scsi: storvsc
> 
> 
> 
> > -----Original Message-----
> > From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> > Sent: Tuesday, June 04, 2013 3:05 PM
> > To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> > hch@infradead.org; linux-scsi@vger.kernel.org
> > Cc: KY Srinivasan
> > Subject: [PATCH V3 0/5] Drivers: scsi: storvsc
> >
> > This set adds multi-channel support as well synthetic Fibre Channel support
> > to storvsc. The multi-channel support depends on infrastructure in the VMBUS
> > driver. Greg has already checked in the relevant patches to VMBUS.
> >
> > I had posted an earlier version of this patch-set that included the VMBUS
> > related changes. I have since separated the VMBUS chages and these have
> > already been
> > checked in.
> >
> > In this version, based on comments from James, the timeout is no longer a
> > module
> > parameter.
> 
> James,
> 
> I think I have addressed all the comments that you had; if not, please let me
> know.

Ping.

Regards,

K. Y

