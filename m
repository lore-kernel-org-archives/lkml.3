Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbaCNVHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:07:31 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:38489
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755472AbaCNVH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:07:29 -0400
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Mar 2014 17:07:29 EDT
From: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] USB : Gadget: fsl: add information message
Thread-Topic: [PATCH] USB : Gadget: fsl: add information message
Thread-Index: AQHPPo+r//dUnp3nNkCMJIQoikhfFJrfI/MAgAHeuzA=
Date: Fri, 14 Mar 2014 20:52:49 +0000
Message-ID: <2b425ae9fdcc4fe8959b4d366070cd0d@BN1PR03MB251.namprd03.prod.outlook.com>
References: <1394716310-27001-1-git-send-email-suresh.gupta@freescale.com>
 <20140313152600.GH4599@saruman.home>
In-Reply-To: <20140313152600.GH4599@saruman.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(24454002)(189002)(199002)(51704005)(76786001)(77096001)(76482001)(53806001)(54356001)(51856001)(69226001)(50986001)(19580405001)(575784001)(85852003)(93516002)(46102001)(66066001)(65816001)(80022001)(77982001)(86362001)(81686001)(83322001)(59766001)(33646001)(76796001)(76576001)(49866001)(56776001)(19580395003)(81342001)(80976001)(4396001)(81816001)(74366001)(2656002)(20776003)(79102001)(95666003)(74662001)(92566001)(31966008)(97186001)(94316002)(90146001)(54316002)(87266001)(74706001)(93136001)(47736001)(83072002)(47446002)(81542001)(87936001)(63696002)(95416001)(74876001)(74502001)(74316001)(85306002)(97336001)(47976001)(94946001)(56816005)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB024;H:BN1PR03MB251.namprd03.prod.outlook.com;FPR:B41CF151.7F3ACD5.73EA51A7.416CFA79.20271;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

-----Original Message-----
From: Felipe Balbi [mailto:balbi@ti.com] 
Sent: Thursday, March 13, 2014 8:56 PM
To: Gupta Suresh-B42813
Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB : Gadget: fsl: add information message

On Thu, Mar 13, 2014 at 06:41:50PM +0530, Suresh Gupta wrote:
> 	Message helps to understand that the Freescale Gadget driver
> 	is up without any error.

why this tab ?
[SuresH] I will remove it in next version 

> 
> Signed-off-by: Suresh Gupta <suresh.gupta@freescale.com>
> ---
>  drivers/usb/gadget/fsl_udc_core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/gadget/fsl_udc_core.c 
> b/drivers/usb/gadget/fsl_udc_core.c
> index 9a93727..455d0ab 100644
> --- a/drivers/usb/gadget/fsl_udc_core.c
> +++ b/drivers/usb/gadget/fsl_udc_core.c
> @@ -2503,6 +2503,7 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
>  		goto err_del_udc;
>  
>  	create_proc_file();
> +	pr_info("%s (%s)\n", driver_desc, DRIVER_VERSION);

if there are no messages, then it's up. Also, you can very easily check lsmod.

sorry, but I'm not taking this.
[SuresH] The legacy driver shows this message when module_init was used. To make same upbringing for customer, I added the same message after probe get  completed. This message will not make any difference but will satisfies customer need.   

>  	return 0;
>  
>  err_del_udc:
> --
> 1.8.4.1
> 
> 

--
Thanks
SuresH
