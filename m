Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaHFB62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 21:58:28 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:2766
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755280AbaHFB6T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 21:58:19 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "broonie@kernel.org" <broonie@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCHv6 0/2] add DT endianness binding support for regmap
Thread-Topic: [PATCHv6 0/2] add DT endianness binding support for regmap
Thread-Index: AQHPn+T8nTHLUXNU9EaaWE4AokpmnpvC83Dg
Date: Wed, 6 Aug 2014 01:58:15 +0000
Message-ID: <d7b74069c0ef44c0bbcae8454cb9266b@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1405398183-31345-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1405398183-31345-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(13464003)(377454003)(189002)(199002)(164054003)(2656002)(87936001)(19580395003)(83072002)(85852003)(83322001)(19580405001)(107046002)(77096002)(106116001)(106356001)(95666004)(99286002)(99396002)(21056001)(54356999)(76176999)(50986999)(105586002)(85306004)(74316001)(76482001)(20776003)(64706001)(74502001)(66066001)(80022001)(4396001)(33646002)(76576001)(77982001)(46102001)(79102001)(86362001)(101416001)(81542001)(81342001)(24736002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0616;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to know the status about this patch series, there are many patches
Based the Regmap still waiting for these.

Thanks,
BRs
Xiubo


> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Tuesday, July 15, 2014 12:23 PM
> To: broonie@kernel.org; mark.rutland@arm.com
> Cc: robh+dt@kernel.org; pawel.moll@arm.com; ijc+devicetree@hellion.org.uk;
> galak@codeaurora.org; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devicetree@vger.kernel.org; Xiubo Li-B47053
> Subject: [PATCHv6 0/2] add DT endianness binding support for regmap
> 
> Changes in V6:
> - there is some mistake for V5 patch series, resend it.
> 
> Changes in V5:
> - remove the register's dt endianness support for it will always be BE
>   for now.
> - only support the register values buffers dt endianness support.
> 
> 
> 
> Xiubo Li (2):
>   regmap: add DT endianness binding support.
>   dt/bindings: Add the DT binding documentation for endianness
> 
>  .../devicetree/bindings/regmap/regmap.txt          |  48 +++++++++
>  drivers/base/regmap/regmap-i2c.c                   |   2 +
>  drivers/base/regmap/regmap-spi.c                   |   2 +
>  drivers/base/regmap/regmap.c                       | 117 +++++++++++++++++++-
> -
>  4 files changed, 158 insertions(+), 11 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/regmap/regmap.txt
> 
> --
> 1.8.5

