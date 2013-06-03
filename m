Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523Ab3FCX0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 19:26:10 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:59825
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758747Ab3FCXZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 19:25:58 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz98dI9371I936eI542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh17ej9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <jbottomley@parallels.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/5] Drivers: scsi: storvsc: Make the scsi timeout a
 module parameter
Thread-Topic: [PATCH 1/5] Drivers: scsi: storvsc: Make the scsi timeout a
 module parameter
Thread-Index: AQHOYKxAJGrjXDxyYEGEh8dfafipzpkkm6WAgAAAcdA=
Date: Mon, 3 Jun 2013 23:25:44 +0000
Message-ID: <154d86b83ab94931a097c32e1c8e4987@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1370301519-27196-1-git-send-email-kys@microsoft.com>
	 <1370301688-27286-1-git-send-email-kys@microsoft.com>
 <1370300581.2013.14.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1370300581.2013.14.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:0:fff:0:5efe:172.19.16.128]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB061.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%INFRADEAD.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%PARALLELS.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(24454002)(377424003)(51704005)(377454002)(189002)(13464003)(199002)(76796001)(20776003)(49866001)(33646001)(79102001)(81542001)(4396001)(47446002)(76576001)(74662001)(47976001)(50986001)(47736001)(74502001)(54356001)(56816002)(80022001)(65816001)(56776001)(63696002)(46102001)(31966008)(54316002)(47776003)(69226001)(53806001)(76482001)(74876001)(23726002)(51856001)(74316001)(6806003)(16676001)(74366001)(76786001)(44976003)(59766001)(77982001)(74706001)(50466002)(46406003)(81342001)(3826001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB033;H:TK5EX14HUBC107.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 08660C8631
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Monday, June 03, 2013 7:03 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH 1/5] Drivers: scsi: storvsc: Make the scsi timeout a module
> parameter
> 
> On Mon, 2013-06-03 at 16:21 -0700, K. Y. Srinivasan wrote:
> > The standard scsi timeout is not appropriate in some of the environments
> where
> > Hyper-V is deployed. Set this timeout appropriately for all devices managed
> > by this driver. Further make this a module parameter.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/scsi/storvsc_drv.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > index 16a3a0c..8d29a95 100644
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -221,6 +221,13 @@ static int storvsc_ringbuffer_size = (20 * PAGE_SIZE);
> >  module_param(storvsc_ringbuffer_size, int, S_IRUGO);
> >  MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
> >
> > +/*
> > + * Timeout in seconds for all devices managed by this driver.
> > + */
> > +static int storvsc_timeout = 180;
> > +module_param(storvsc_timeout, uint, (S_IRUGO | S_IWUSR));
> > +MODULE_PARM_DESC(storvsc_timeout, "Device timeout (seconds)");
> > +
> >  #define STORVSC_MAX_IO_REQUESTS				128
> >
> >  /*
> > @@ -1204,6 +1211,8 @@ static int storvsc_device_configure(struct scsi_device
> *sdevice)
> >
> >  	blk_queue_bounce_limit(sdevice->request_queue, BLK_BOUNCE_ANY);
> >
> > +	blk_queue_rq_timeout(sdevice->request_queue, (storvsc_timeout *
> HZ));
> 
> Why does this need to be a module parameter?  It's already a sysfs one
> in the scsi_device class?  Three minutes is also a bit large.  The
> default is 30s with huge cache arrays recommending upping this to
> 60s ... you're three times this.

James,
This number was arrived at based on some testing that was done on the cloud. On our cloud, we have a  120 second
timeouts that trigger broader VM level recovery  and in cases where there is storage access issues
(which is when we would hit this timeout), it will be better to defer to the fabric level recovery than attempt
Scsi level recovery/retry.  The default value chosen for devices managed by storvsc should be just fine, 
I made it a module parameter to have more flexibility.

Regards,

K. Y  
> 
> James
> 
> 


