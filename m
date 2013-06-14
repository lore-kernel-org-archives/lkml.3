Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3FNVg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:36:56 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:5817
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754215Ab3FNVgw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:36:52 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zz98dI9371Ic89bh936eI542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz31h2a8h668h839h947hd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
CC: Fernando Soto <fsoto@bluecatnetworks.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] Drivers: hv: vmbus: incorrect device name is printed
 when child device is unregistered
Thread-Topic: [PATCH] Drivers: hv: vmbus: incorrect device name is printed
 when child device is unregistered
Thread-Index: Ac5okEkVBpap2M3qQqqQ0UUeLNbP9QAE3nQwAB3m44AACutyIA==
Date: Fri, 14 Jun 2013 21:36:07 +0000
Message-ID: <0a644e26a9dc4849938107fb6b713911@SN2PR03MB061.namprd03.prod.outlook.com>
References: <88E08D85EE353144A618C55479FE1117411FD9A9@TORMBXW01.bluecatnetworks.corp>
 <21ce39ca10234c2fae6f98b029d86b5c@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130614162231.GA14829@kroah.com>
In-Reply-To: <20130614162231.GA14829@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB061.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%BLUECATNETWORKS.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377424003)(24454002)(51704005)(199002)(377454002)(13464003)(189002)(74366001)(74662001)(50466002)(47446002)(76482001)(56776001)(53806001)(51856001)(33646001)(79102001)(74502001)(46102001)(47736001)(23756003)(74876001)(59766001)(54356001)(47776003)(50986001)(63696002)(16676001)(20776003)(74706001)(77982001)(76786001)(4396001)(47976001)(6806003)(76576001)(80022001)(65816001)(31966008)(69226001)(66066001)(44976003)(56816003)(81542001)(74316001)(49866001)(77096001)(54316002)(81342001)(76796001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB021;H:TK5EX14MLTC104.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;A:1;MX:3;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 08770259B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH (gregkh@linuxfoundation.org)
> [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, June 14, 2013 12:23 PM
> To: KY Srinivasan
> Cc: Fernando Soto; linux-kernel@vger.kernel.org; Haiyang Zhang
> Subject: Re: [PATCH] Drivers: hv: vmbus: incorrect device name is printed when
> child device is unregistered
> 
> On Fri, Jun 14, 2013 at 02:13:44AM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Fernando Soto [mailto:fsoto@bluecatnetworks.com]
> > > Sent: Thursday, June 13, 2013 8:11 PM
> > > To: linux-kernel@vger.kernel.org
> > > Cc: KY Srinivasan; Haiyang Zhang
> > > Subject: [PATCH] Drivers: hv: vmbus: incorrect device name is printed when
> child
> > > device is unregistered
> > >
> > > From: Fernando Soto <fsoto@bluecatnetworks.com>
> > > Please CC me, I am not subscribed to the list.
> > >
> > > Whenever a device is unregistered in vmbus_device_unregister
> > > (drivers/hv/vmbus_drv.c), the device name in the log message may contain
> > > garbage as the memory has already been freed by the time pr_info is called.
> Log
> > > example:
> > >  [ 3149.170475] hv_vmbus: child device ахsии0_5 unregistered
> > >
> > > By logging the message just before calling device_unregister, the correct
> device
> > > name is printed:
> > > [ 3145.034652] hv_vmbus: child device vmbus_0_5 unregistered
> > >
> > > Signed-off-by: Fernando M Soto <fsoto@bluecatnetworks.com>
> > Acked-by: K. Y. Srinivasan <kys@microsoft.com>
> >
> > > --- linux-3.10-rc5/drivers/hv/vmbus_drv.c.orig	2013-06-13
> 19:20:55.359511352 -
> > > 0400
> > > +++ linux-3.10-rc5/drivers/hv/vmbus_drv.c	2013-06-13 19:21:39.299511695 -
> > > 0400
> > > @@ -698,14 +698,14 @@ int vmbus_device_register(struct hv_devi
> > >   */
> > >  void vmbus_device_unregister(struct hv_device *device_obj)
> > >  {
> > > +	pr_info("child device %s unregistered\n",
> > > +		dev_name(&device_obj->device));
> > > +
> > >  	/*
> > >  	 * Kick off the process of unregistering the device.
> > >  	 * This will call vmbus_remove() and eventually vmbus_device_release()
> > >  	 */
> > >  	device_unregister(&device_obj->device);
> > > -
> > > -	pr_info("child device %s unregistered\n",
> > > -		dev_name(&device_obj->device));
> 
> No, please just remove these entirely, or make them pr_debug(), you
> shouldn't clutter up the kernel log for stuff like this.

Agreed. Fernando, do you want to submit a patch as suggested by Greg.

K. Y
> 
> thanks,
> 
> greg k-h
> 


