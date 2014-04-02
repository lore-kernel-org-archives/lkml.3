Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbaDBL32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:29:28 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:21170
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758420AbaDBL30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:29:26 -0400
X-Greylist: delayed 891 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2014 07:29:26 EDT
From: "Haijun.Zhang@freescale.com" <Haijun.Zhang@freescale.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "broonie@kernel.org" <broonie@kernel.org>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Subject: RE: [PATCHv2 0/3] regmap: add LE and DT binding for endianness
Thread-Topic: [PATCHv2 0/3] regmap: add LE and DT binding for endianness
Thread-Index: AQHPTmGs8EWk059ojUa9NNpTPq6m4Zr+Jshw
Date: Wed, 2 Apr 2014 11:14:32 +0000
Message-ID: <e6c89c0c983041fba39110b5517b7605@DM2PR03MB384.namprd03.prod.outlook.com>
References: <1396433349-31470-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1396433349-31470-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(377454003)(13464003)(76576001)(15975445006)(76786001)(49866001)(74876001)(31966008)(90146001)(74502001)(19580405001)(66066001)(47976001)(63696002)(54356001)(51856001)(81686001)(99396002)(87936001)(81542001)(87266001)(76796001)(95666003)(56776001)(50986001)(86362001)(54316002)(53806001)(81342001)(74316001)(74366001)(80022001)(83322001)(47736001)(83072002)(2656002)(94316002)(98676001)(79102001)(93516002)(97186001)(94946001)(93136001)(59766001)(33646001)(19580395003)(47446002)(77982001)(99286001)(4396001)(69226001)(65816001)(92566001)(85852003)(74706001)(76482001)(15202345003)(20776003)(81816001)(56816005)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB512;H:DM2PR03MB384.namprd03.prod.outlook.com;FPR:B865C9A6.9803CF12.B1D57720.C0E4DAF9.20221;MLV:sfv;PTR:InfoNoRecords;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Xiubo Li
> Sent: Wednesday, April 02, 2014 6:09 PM
> To: broonie@kernel.org
> Cc: linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org; Xiubo Li-
> B47053
> Subject: [PATCHv2 0/3] regmap: add LE and DT binding for endianness
>


This patch set is very useful for eSDHC driver, which will support
different endiannesses on both powerpc and arm platforms at the
same time.

And this patch set looks good to me.

> 
> For this patch series has dependency, so resend them together.
> 
> 
> Change in v2:
> - resend 'regmap: implement LE formatting/parsing for 16/32-bit values.'
> - resend 'regmap: Add the DT binding documentation for endianness'
> - fix the commit message of 'regmap: add DT endianness binding support.'
> 
> 
> 
> 
> Xiubo Li (3):
>   regmap: implement LE formatting/parsing for 16/32-bit values.
>   regmap: Add the DT binding documentation for endianness
>   regmap: add DT endianness binding support.
> 
>  .../bindings/regmap/regmap-endianness.txt          |  49 +++++++
>  drivers/base/regmap/regmap.c                       | 141
> +++++++++++++++++++--
>  2 files changed, 180 insertions(+), 10 deletions(-)  create mode 100644
> Documentation/devicetree/bindings/regmap/regmap-endianness.txt
> 
> --
> 1.8.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

