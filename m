Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab3FYSQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:16:48 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:27693
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751101Ab3FYSQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:16:47 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz9371Ic89bh936eI542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz31h2a8h668h839h947hd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Fernando Soto <fsoto@bluecatnetworks.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH v2] Drivers: hv: vmbus: incorrect device name is printed
 when child device is unregistered
Thread-Topic: [PATCH v2] Drivers: hv: vmbus: incorrect device name is
 printed when child device is unregistered
Thread-Index: Ac5pU48P+9pU60c1SYeKRdNDlua1+wIe5BCw
Date: Tue, 25 Jun 2013 18:14:43 +0000
Message-ID: <f12ad73f92264a15b373a50b149e537e@SN2PR03MB061.namprd03.prod.outlook.com>
References: <88E08D85EE353144A618C55479FE1117411FEE44@TORMBXW01.bluecatnetworks.corp>
In-Reply-To: <88E08D85EE353144A618C55479FE1117411FEE44@TORMBXW01.bluecatnetworks.corp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%BLUECATNETWORKS.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454003)(51704005)(13464003)(199002)(189002)(377424004)(66066001)(33646001)(80022001)(74366001)(53806001)(50466002)(65816001)(81542001)(74316001)(54316002)(74662001)(76796001)(56816003)(56776001)(79102001)(47776003)(63696002)(76786001)(23756003)(47446002)(76576001)(74706001)(6806003)(77982001)(54356001)(49866001)(4396001)(74876001)(20776003)(47976001)(16676001)(31966008)(46102001)(69226001)(47736001)(77096001)(59766001)(81342001)(44976004)(74502001)(76482001)(50986001)(51856001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB027;H:TK5EX14MLTC104.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0888B1D284
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Fernando Soto [mailto:fsoto@bluecatnetworks.com]
> Sent: Friday, June 14, 2013 7:14 PM
> To: linux-kernel@vger.kernel.org
> Cc: Haiyang Zhang; KY Srinivasan; Greg KH (gregkh@linuxfoundation.org)
> Subject: [PATCH v2] Drivers: hv: vmbus: incorrect device name is printed when
> child device is unregistered
> 
> From: Fernando Soto <fsoto@bluecatnetworks.com>
> Please CC me, I am not subscribed to the list.
> 
> Whenever a device is unregistered in vmbus_device_unregister
> (drivers/hv/vmbus_drv.c), the device name in the log message may contain
> garbage as the memory has already been freed by the time pr_info is called. Log
> example:
>  [ 3149.170475] hv_vmbus: child device ахsии0_5 unregistered
> 
> By logging the message just before calling device_unregister, the correct device
> name is printed:
> [ 3145.034652] hv_vmbus: child device vmbus_0_5 unregistered
> 
> Also changing register & unregister messages to debug to avoid unnecessarily
> cluttering the kernel log.
> 
> Signed-off-by: Fernando M Soto <fsoto@bluecatnetworks.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> --- linux-3.10-rc5/drivers/hv/vmbus_drv.c.orig	2013-06-13 19:20:55.359511352 -
> 0400
> +++ linux-3.10-rc5/drivers/hv/vmbus_drv.c	2013-06-14 19:00:21.722105728 -
> 0400
> @@ -686,7 +686,7 @@ int vmbus_device_register(struct hv_devi
>  	if (ret)
>  		pr_err("Unable to register child device\n");
>  	else
> -		pr_info("child device %s registered\n",
> +		pr_debug("child device %s registered\n",
>  			dev_name(&child_device_obj->device));
> 
>  	return ret;
> @@ -698,14 +698,14 @@ int vmbus_device_register(struct hv_devi
>   */
>  void vmbus_device_unregister(struct hv_device *device_obj)
>  {
> +	pr_debug("child device %s unregistered\n",
> +		dev_name(&device_obj->device));
> +
>  	/*
>  	 * Kick off the process of unregistering the device.
>  	 * This will call vmbus_remove() and eventually vmbus_device_release()
>  	 */
>  	device_unregister(&device_obj->device);
> -
> -	pr_info("child device %s unregistered\n",
> -		dev_name(&device_obj->device));
>  }
> 
> 
> --
> 


