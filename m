Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3C0JVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:21:09 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:20941
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809Ab3C0JVF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:21:05 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh2a8h668h839h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1b0ah1155h)
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Sachin Kamat <sachin.kamat@linaro.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        LKML <linux-kernel@vger.kernel.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>
Date: Wed, 27 Mar 2013 09:20:26 +0000
Subject: AW: [PATCH 1/1] mfd: adp5520: Use module_i2c_driver()
Thread-Topic: [PATCH 1/1] mfd: adp5520: Use module_i2c_driver()
Thread-Index: Ac4qyWed8fswGmuVRdurCDNvVMn/MwAAum7Y
Message-ID: <544AC56F16B56944AEC3BD4E3D591771602C593BF8@LIMKCMBX1.ad.analog.com>
References: <1363347628-15344-1-git-send-email-sachin.kamat@linaro.org>,<CAK9yfHyw+rfgpBW+JiGE4bgv3s5t3nmGxoeqzE-ystq_b+mf8A@mail.gmail.com>
In-Reply-To: <CAK9yfHyw+rfgpBW+JiGE4bgv3s5t3nmGxoeqzE-ystq_b+mf8A@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
Von: Sachin Kamat [sachin.kamat@linaro.org]
Gesendet: Mittwoch, 27. März 2013 09:59
An: device-drivers-devel@blackfin.uclinux.org; LKML
Cc: Hennerich, Michael; sameo@linux.intel.com; sachin.kamat@linaro.org
Betreff: Re: [PATCH 1/1] mfd: adp5520: Use module_i2c_driver()

On 15 March 2013 17:10, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> module_i2c_driver() removes some boilerplate and makes the code
> simple.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Michael Hennerich <michael.hennerich@analog.com>

> ---
>  drivers/mfd/adp5520.c |   12 +-----------
>  1 files changed, 1 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
> index 210dd03..5ab021f 100644
> --- a/drivers/mfd/adp5520.c
> +++ b/drivers/mfd/adp5520.c
> @@ -360,17 +360,7 @@ static struct i2c_driver adp5520_driver = {
>         .id_table       = adp5520_id,
>  };
>
> -static int __init adp5520_init(void)
> -{
> -       return i2c_add_driver(&adp5520_driver);
> -}
> -module_init(adp5520_init);
> -
> -static void __exit adp5520_exit(void)
> -{
> -       i2c_del_driver(&adp5520_driver);
> -}
> -module_exit(adp5520_exit);
> +module_i2c_driver(adp5520_driver);
>
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("ADP5520(01) PMIC-MFD Driver");
> --
> 1.7.4.1
>

ping...


