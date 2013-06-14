Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577Ab3FNCN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:13:57 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:46289
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754493Ab3FNCN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:13:56 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz9371Ic89bh936eI542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz31h2a8h668h839h947hd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Fernando Soto <fsoto@bluecatnetworks.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] Drivers: hv: vmbus: incorrect device name is printed
 when child device is unregistered
Thread-Topic: [PATCH] Drivers: hv: vmbus: incorrect device name is printed
 when child device is unregistered
Thread-Index: Ac5okEkVBpap2M3qQqqQ0UUeLNbP9QAE3nQw
Date: Fri, 14 Jun 2013 02:13:44 +0000
Message-ID: <21ce39ca10234c2fae6f98b029d86b5c@SN2PR03MB061.namprd03.prod.outlook.com>
References: <88E08D85EE353144A618C55479FE1117411FD9A9@TORMBXW01.bluecatnetworks.corp>
In-Reply-To: <88E08D85EE353144A618C55479FE1117411FD9A9@TORMBXW01.bluecatnetworks.corp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.56.200.45]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%BLUECATNETWORKS.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(377424003)(51704005)(13464003)(377454002)(199002)(6806003)(76786001)(66066001)(63696002)(31966008)(81542001)(47976001)(74706001)(80022001)(50986001)(79102001)(49866001)(47776003)(69226001)(33646001)(59766001)(51856001)(74876001)(16676001)(76576001)(23756003)(44976003)(77096001)(53806001)(74366001)(76482001)(56816003)(76796001)(20776003)(47736001)(56776001)(4396001)(54356001)(47446002)(81342001)(46102001)(74502001)(74662001)(54316002)(74316001)(50466002)(65816001)(77982001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB031;H:TK5EX14HUBC106.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 08770259B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Fernando Soto [mailto:fsoto@bluecatnetworks.com]
> Sent: Thursday, June 13, 2013 8:11 PM
> To: linux-kernel@vger.kernel.org
> Cc: KY Srinivasan; Haiyang Zhang
> Subject: [PATCH] Drivers: hv: vmbus: incorrect device name is printed when child
> device is unregistered
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
> Signed-off-by: Fernando M Soto <fsoto@bluecatnetworks.com>
Acked-by: K. Y. Srinivasan <kys@microsoft.com>

> --- linux-3.10-rc5/drivers/hv/vmbus_drv.c.orig	2013-06-13 19:20:55.359511352 -
> 0400
> +++ linux-3.10-rc5/drivers/hv/vmbus_drv.c	2013-06-13 19:21:39.299511695 -
> 0400
> @@ -698,14 +698,14 @@ int vmbus_device_register(struct hv_devi
>   */
>  void vmbus_device_unregister(struct hv_device *device_obj)
>  {
> +	pr_info("child device %s unregistered\n",
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
> 


