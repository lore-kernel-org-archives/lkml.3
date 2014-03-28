Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaC1EPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 00:15:55 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:30505
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751057AbaC1EPv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 00:15:51 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Shawn Guo <Shawn.Guo@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Subject: FW: [PATCHv2 1/2] watchdog: imx2_wdt: Sort the header files
 alphabetically
Thread-Topic: [PATCHv2 1/2] watchdog: imx2_wdt: Sort the header files
 alphabetically
Thread-Index: AQHPSKDU6oomZagoF0ymLk+w9fkj6Zr15zAw
Date: Fri, 28 Mar 2014 04:15:49 +0000
Message-ID: <605e46d4edf64b94939e566e5bfe9c33@BY2PR03MB505.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01644DCF4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(164054003)(199002)(189002)(51704005)(33646001)(69226001)(65816001)(94316002)(76176001)(66066001)(76482001)(93136001)(77982001)(59766001)(92566001)(56776001)(79102001)(76576001)(50986001)(94946001)(80022001)(46102001)(47736001)(49866001)(53806001)(54356001)(93516002)(4396001)(74876001)(20776003)(98676001)(47976001)(74706001)(63696002)(86362001)(97336001)(95416001)(95666003)(81686001)(81816001)(76786001)(56816005)(83322001)(19580405001)(31966008)(74662001)(19580395003)(80976001)(74316001)(90146001)(87936001)(81342001)(85306002)(87266001)(2656002)(81542001)(85852003)(83072002)(74502001)(47446002)(74366001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB345;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:B8CEDBCA.381394CD.C1D15B68.5C62BA89.20176;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forward to Shawn,

Thanks,



> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Wednesday, March 26, 2014 10:22 AM
> To: wim@iguana.be; w.sang@pengutronix.de; linux-watchdog@vger.kernel.org;
> linux@roeck-us.net
> Cc: linux-kernel@vger.kernel.org; Xiubo Li-B47053
> Subject: [PATCHv2 1/2] watchdog: imx2_wdt: Sort the header files
> alphabetically
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/watchdog/imx2_wdt.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> index dd51d95..1795922 100644
> --- a/drivers/watchdog/imx2_wdt.c
> +++ b/drivers/watchdog/imx2_wdt.c
> @@ -21,19 +21,19 @@
>   * Halt on suspend:	Manual		Can be automatic
>   */
> 
> +#include <linux/clk.h>
> +#include <linux/fs.h>
>  #include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/jiffies.h>
>  #include <linux/kernel.h>
>  #include <linux/miscdevice.h>
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
>  #include <linux/platform_device.h>
> -#include <linux/watchdog.h>
> -#include <linux/clk.h>
> -#include <linux/fs.h>
> -#include <linux/io.h>
> -#include <linux/uaccess.h>
>  #include <linux/timer.h>
> -#include <linux/jiffies.h>
> +#include <linux/uaccess.h>
> +#include <linux/watchdog.h>
> 
>  #define DRIVER_NAME "imx2-wdt"
> 
> --
> 1.8.4
> 

