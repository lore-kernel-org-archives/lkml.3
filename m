Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaDCRPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 13:15:17 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:49786
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752845AbaDCRPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 13:15:10 -0400
From: Insop Song <Insop.Song@gainspeed.com>
To: Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: fpgaboot: clean up Makefile
Thread-Topic: [PATCH] staging: fpgaboot: clean up Makefile
Thread-Index: AQHPTxc7HtTQ/1xdE0eGLgS+u6FdVZsAIYEA
Date: Thu, 3 Apr 2014 17:14:44 +0000
Message-ID: <11311c2b04f447a88709cab3a095045f@BY2PR07MB011.namprd07.prod.outlook.com>
References: <20140401184817.GA21855@kroah.com>
	 <1396427043.18431.20.camel@x220> <20140402200428.GE26966@kroah.com>
	 <7731bd53be4b49e2924a7002f74dc090@BY2PR07MB011.namprd07.prod.outlook.com>
 <1396513937.31985.14.camel@x220>
In-Reply-To: <1396513937.31985.14.camel@x220>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.60.97.2]
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(24454002)(189002)(199002)(52034003)(377454003)(33646001)(47976001)(95416001)(97336001)(77096001)(76576001)(81686001)(69226001)(98676001)(74706001)(2656002)(74316001)(76786001)(76796001)(81816001)(97186001)(47446002)(87266001)(80976001)(49866001)(4396001)(94316002)(74502001)(74662001)(83072002)(66066001)(51856001)(79102001)(54316002)(81542001)(31966008)(85852003)(74366001)(50986001)(59766001)(19580405001)(77982001)(87936001)(56776001)(56816005)(65816001)(99286001)(93516002)(92566001)(90146001)(81342001)(74876001)(19580395003)(63696002)(83322001)(53806001)(86362001)(54356001)(99396002)(80022001)(46102001)(93136001)(85306002)(95666003)(47736001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR07MB009;H:BY2PR07MB011.namprd07.prod.outlook.com;FPR:F7D1C07E.9404677F.72519BC2.B0D0FE7D.2016E;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: gainspeed.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s33HFQaj019083

Added signed-off-by below:

On Thursday, April 03, 2014 1:32 AM, Paul Bolle wrote:
> 
> This Makefile tries to set the DEBUG macro but it uses an unknown Kconfig
> macro to do so. Since no code appears to even care about the DEBUG macro
> this line can safely be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Signed-off-by: Insop Song <insop.song@gainspeed.com>

> ---
> Completely untested.
> 
> By the way, do devel@driverdev.osuosl.org and
> devel@linuxdriverproject.org deliver to the same list?
> 
>  drivers/staging/gs_fpgaboot/Makefile | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/staging/gs_fpgaboot/Makefile
> b/drivers/staging/gs_fpgaboot/Makefile
> index 34cb606..d2f0211 100644
> --- a/drivers/staging/gs_fpgaboot/Makefile
> +++ b/drivers/staging/gs_fpgaboot/Makefile
> @@ -1,4 +1,2 @@
>  gs_fpga-y	+= gs_fpgaboot.o io.o
>  obj-$(CONFIG_GS_FPGABOOT)	+= gs_fpga.o
> -
> -ccflags-$(CONFIG_GS_FPGA_DEBUG)	:= -DDEBUG
> --
> 1.9.0

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
