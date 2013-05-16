Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab3EPOCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:02:10 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:31438
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751044Ab3EPOCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:02:07 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
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
Thread-Index: AQHOUitiVwQUU7XHlU2Pz3ZoUJwmQZkHtgAAgAAQVOCAAA9gAIAAAP4g
Date: Thu, 16 May 2013 14:01:12 +0000
Message-ID: <fe60584bb8f2485abebffab2d0e8722d@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1368706784-32276-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-7-git-send-email-kys@microsoft.com>
 <20130516120200.GN1360@mwanda>
 <797ed8d967414124a00ee151077c70fa@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130516135528.GX30128@mwanda>
In-Reply-To: <20130516135528.GX30128@mwanda>
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
X-FOPE-CONNECTOR: Id%59$Dn%INFRADEAD.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%PARALLELS.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ORACLE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(24454002)(51704005)(13464003)(377454002)(189002)(199002)(54316002)(69226001)(81342001)(16676001)(63696002)(79102001)(50466002)(80022001)(74316001)(47976001)(66066001)(50986001)(53806001)(6806003)(76482001)(74706001)(59766001)(4396001)(31966008)(74876001)(47736001)(74662001)(74502001)(46102001)(47446002)(74366001)(33646001)(56816002)(51856001)(54356001)(47776003)(46406003)(77982001)(49866001)(44976003)(23726002)(20776003)(65816001)(81542001)(56776001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB020;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0848C1A6AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Thursday, May 16, 2013 9:55 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> hch@infradead.org; linux-scsi@vger.kernel.org; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH V1 7/7] Drivers: scsi: storvsc: Increase the value of
> STORVSC_MAX_IO_REQUESTS
> 
> On Thu, May 16, 2013 at 01:37:41PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > > Sent: Thursday, May 16, 2013 8:02 AM
> > > To: KY Srinivasan
> > > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com;
> > > hch@infradead.org; linux-scsi@vger.kernel.org; apw@canonical.com;
> > > jasowang@redhat.com
> > > Subject: Re: [PATCH V1 7/7] Drivers: scsi: storvsc: Increase the value of
> > > STORVSC_MAX_IO_REQUESTS
> > >
> > > On Thu, May 16, 2013 at 05:21:19AM -0700, K. Y. Srinivasan wrote:
> > > > Increase the value of STORVSC_MAX_IO_REQUESTS to 200 requests. The
> > > current
> > > > ringbuffer size can support this higher value.
> > > >
> > >
> > > The ringbuffer size is a module parameter so it's odd to talk about
> > > the "current" size.
> >
> > While the ringbuffer size is a module parameter; there is a default value. The
> current size refers to the default.
> > Your comment applies to the current value (of 128) as well in that it is possible
> for somebody to load this
> > driver  with a ringbuffer size that could not support  the value of 128. If this  is
> the case, we fail the load.
> > This safety check continues to exist.
> 
> The issue is there in the original code, true.
> 
> Would the right fix be to add some sanity checks in module_init()?

The check is already there (as I noted above). Look at the function:
storvsc_drv_init(). If the ring size is picked incorrectly, the load is failed.

Regards,

K. Y
> 
> regards,
> dan carpenter
> 
> 


