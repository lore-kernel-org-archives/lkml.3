Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3EPNjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:39:06 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:52132
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753526Ab3EPNjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:39:03 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V1 7/7] Drivers: scsi: storvsc: Increase the value of
 STORVSC_MAX_IO_REQUESTS
Thread-Topic: [PATCH V1 7/7] Drivers: scsi: storvsc: Increase the value of
 STORVSC_MAX_IO_REQUESTS
Thread-Index: AQHOUitiVwQUU7XHlU2Pz3ZoUJwmQZkHtgAAgAAQVOA=
Date: Thu, 16 May 2013 13:37:41 +0000
Message-ID: <797ed8d967414124a00ee151077c70fa@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1368706784-32276-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-7-git-send-email-kys@microsoft.com>
 <20130516120200.GN1360@mwanda>
In-Reply-To: <20130516120200.GN1360@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%INFRADEAD.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%PARALLELS.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ORACLE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(24454002)(13464003)(377454002)(199002)(189002)(51704005)(51856001)(81542001)(81342001)(50986001)(47976001)(69226001)(23726002)(46102001)(65816001)(49866001)(80022001)(16676001)(47736001)(66066001)(54356001)(54316002)(50466002)(56816002)(53806001)(56776001)(33646001)(44976003)(20776003)(47776003)(63696002)(79102001)(47446002)(59766001)(74316001)(74502001)(74876001)(46406003)(77982001)(74366001)(6806003)(74662001)(76482001)(31966008)(4396001)(74706001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB033;H:TK5EX14HUBC104.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0848C1A6AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Thursday, May 16, 2013 8:02 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> hch@infradead.org; linux-scsi@vger.kernel.org; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH V1 7/7] Drivers: scsi: storvsc: Increase the value of
> STORVSC_MAX_IO_REQUESTS
> 
> On Thu, May 16, 2013 at 05:21:19AM -0700, K. Y. Srinivasan wrote:
> > Increase the value of STORVSC_MAX_IO_REQUESTS to 200 requests. The
> current
> > ringbuffer size can support this higher value.
> >
> 
> The ringbuffer size is a module parameter so it's odd to talk about
> the "current" size.

While the ringbuffer size is a module parameter; there is a default value. The current size refers to the default. 
Your comment applies to the current value (of 128) as well in that it is possible for somebody to load this
driver  with a ringbuffer size that could not support  the value of 128. If this  is the case, we fail the load.
This safety check continues to exist. 

Regards,

K. Y
> 
> regards,
> dan carpenter
> 
> 


