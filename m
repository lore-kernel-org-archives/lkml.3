Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbaCNVID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:08:03 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:31956
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755936AbaCNVIA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:08:00 -0400
From: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in platform
 device id
Thread-Topic: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in platform
 device id
Thread-Index: AQHPPpdRgmsBtN4byECY9YgUxW/lcprfJAUAgAHdeiA=
Date: Fri, 14 Mar 2014 20:52:19 +0000
Message-ID: <71f42b215c58414d8bfa7efb968dadbf@BN1PR03MB251.namprd03.prod.outlook.com>
References: <1394719531-27062-1-git-send-email-suresh.gupta@freescale.com>
 <20140313152628.GI4599@saruman.home>
In-Reply-To: <20140313152628.GI4599@saruman.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(377454003)(52604005)(51704005)(24454002)(81542001)(19580405001)(83322001)(87266001)(19580395003)(95666003)(74662001)(31966008)(47446002)(74502001)(87936001)(2656002)(94946001)(97336001)(80976001)(97186001)(4396001)(53806001)(46102001)(54356001)(56776001)(50986001)(47976001)(76482001)(54316002)(49866001)(47736001)(51856001)(33646001)(81342001)(74876001)(77982001)(90146001)(56816005)(59766001)(74316001)(66066001)(92566001)(79102001)(83072002)(85852003)(80022001)(93516002)(85306002)(86362001)(69226001)(93136001)(81686001)(95416001)(94316002)(81816001)(74706001)(65816001)(74366001)(63696002)(20776003)(77096001)(76576001)(76786001)(76796001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB023;H:BN1PR03MB251.namprd03.prod.outlook.com;FPR:F45C755D.16309CEA.1FB7B60.9154FA79.2023A;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Thanks for reviewing my patches.
Please find my comments inline

-----Original Message-----
From: Felipe Balbi [mailto:balbi@ti.com] 
Sent: Thursday, March 13, 2014 8:56 PM
To: Gupta Suresh-B42813
Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Gupta Suresh-B42813
Subject: Re: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in platform device id

On Thu, Mar 13, 2014 at 07:35:31PM +0530, Suresh Gupta wrote:
> From: Suresh Gupta <B42813@freescale.com>
> 
> 	Add FSL USB Gadget entry in platform device id table

why this tab ?
[SuresH] I will remove it in next version. 

> Signed-off-by: Suresh Gupta <B42813@freescale.com>
> ---
>  drivers/usb/gadget/fsl_udc_core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
> index b7dea4e..35b20e6 100644
> --- a/drivers/usb/gadget/fsl_udc_core.c
> +++ b/drivers/usb/gadget/fsl_udc_core.c
> @@ -2654,6 +2654,8 @@ static const struct platform_device_id fsl_udc_devtype[] = {
>  	}, {
>  		.name = "imx-udc-mx51",
>  	}, {
> +		.name = "fsl-usb2-udc",

why aren't you just using chipidea ?
[SuresH] This is our legacy driver for all previous and existing ppc socs. Many of our customers are already using this, and we need to support them on this driver. We do have plans to shift to chipidea, but after some time. 

-- 
Thanks
SuresH
