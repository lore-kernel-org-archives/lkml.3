Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaCCB6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 20:58:33 -0500
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:47297
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751539AbaCCB6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 20:58:32 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCHv2 1/3] ASoC: codec: Simplify ASoC probe
 code.
Thread-Topic: [alsa-devel] [PATCHv2 1/3] ASoC: codec: Simplify ASoC probe
 code.
Thread-Index: AQHPNG1ZE66RA7TcJUK0BpBMQvyaLprKvZUAgAPgZvA=
Date: Mon, 3 Mar 2014 01:58:15 +0000
Message-ID: <32a973ecbe3446d2a54a9ec620baf338@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1393578267-18255-1-git-send-email-Li.Xiubo@freescale.com>
 <1393578267-18255-2-git-send-email-Li.Xiubo@freescale.com>
 <5310A030.8040201@metafoo.de>
In-Reply-To: <5310A030.8040201@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0139052FDB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(51704005)(47446002)(74502001)(2656002)(94316002)(86362001)(87266001)(31966008)(74662001)(74876001)(93516002)(65816001)(80022001)(94946001)(66066001)(93136001)(85306002)(76796001)(76576001)(4396001)(95666003)(63696002)(47736001)(33646001)(49866001)(74706001)(92566001)(47976001)(50986001)(87936001)(76786001)(79102001)(76482001)(81542001)(74316001)(69226001)(46102001)(51856001)(81816001)(85852003)(83072002)(54356001)(74366001)(54316002)(56776001)(83322001)(59766001)(77982001)(90146001)(56816005)(81342001)(80976001)(81686001)(53806001)(95416001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB428;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Looks good in general, but try to build these kinds of changes with
> CONFIG_COMPILE_TEST=y and CONFIG_SND_SOC_ALL_CODECS=y before sending the
> patch. There are a lot of warnings about unused variables caused by this patch.
> 
@Lars,

Oh, yes, these are very low-level errors, I will fix them then.

Thanks very much.

> sound/soc/codecs/ad193x.c: In function 'ad193x_codec_probe':
> sound/soc/codecs/ad193x.c:343:2: warning: 'ret' is used uninitialized in
> this function [-Wuninitialized]
> sound/soc/codecs/adau1373.c: In function 'adau1373_probe':
> sound/soc/codecs/adau1373.c:1379:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/adav80x.c: In function 'adav80x_probe':
> sound/soc/codecs/adav80x.c:804:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/ak4535.c: In function 'ak4535_probe':
> sound/soc/codecs/ak4535.c:392:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/ak4535.c:391:22: warning: unused variable 'ak4535'
> [-Wunused-variable]
> sound/soc/codecs/ak4641.c: In function 'ak4641_probe':
> sound/soc/codecs/ak4641.c:522:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/ak4642.c: In function 'ak4642_probe':
> sound/soc/codecs/ak4642.c:468:6: warning: unused variable 'ret' [-Wunused-
> sound/soc/codecs/ak4671.c: In function 'ak4671_probe':
> sound/soc/codecs/ak4671.c:620:2: warning: 'ret' is used uninitialized in
> this function [-Wuninitialized]
> sound/soc/codecs/cs42l52.c: In function 'cs42l52_probe':
> sound/soc/codecs/cs42l52.c:1125:2: warning: 'ret' is used uninitialized in
> this function [-Wuninitialized]
> sound/soc/codecs/cs42l73.c: In function 'cs42l73_probe':
> sound/soc/codecs/cs42l73.c:1363:2: warning: 'ret' is used uninitialized in
> this function [-Wuninitialized]
> sound/soc/codecs/da7210.c: In function 'da7210_probe':
> sound/soc/codecs/da7210.c:1074:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/da7213.c: In function 'da7213_probe':
> sound/soc/codecs/da7213.c:1396:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/da732x.c: In function 'da732x_probe':
> sound/soc/codecs/da732x.c:1522:1: warning: label 'err' defined but not used
> [-Wunused-label]
> sound/soc/codecs/da9055.c: In function 'da9055_probe':
> sound/soc/codecs/da9055.c:1386:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/max9850.c: In function 'max9850_probe':
> sound/soc/codecs/max9850.c:315:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/ml26124.c: In function 'ml26124_probe':
> sound/soc/codecs/ml26124.c:590:23: warning: unused variable 'priv'
> [-Wunused-variable]
> sound/soc/codecs/ml26124.c:589:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/rt5631.c: In function 'rt5631_probe':
> sound/soc/codecs/rt5631.c:1573:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/rt5640.c: In function 'rt5640_probe':
> sound/soc/codecs/rt5640.c:1939:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/ssm2518.c: In function 'ssm2518_probe':
> sound/soc/codecs/ssm2518.c:652:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/ssm2518.c:651:18: warning: unused variable 'ssm2518'
> [-Wunused-variable]
> sound/soc/codecs/sta32x.c: In function 'sta32x_probe':
> sound/soc/codecs/sta32x.c:940:1: warning: label 'err' defined but not used
> [-Wunused-label]
> sound/soc/codecs/sta529.c: In function 'sta529_probe':
> sound/soc/codecs/sta529.c:326:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/sta529.c:325:17: warning: unused variable 'sta529'
> [-Wunused-variable]
> sound/soc/codecs/tlv320aic23.c: In function 'tlv320aic23_probe':
> sound/soc/codecs/tlv320aic23.c:562:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/wm8510.c: In function 'wm8510_probe':
> sound/soc/codecs/wm8510.c:599:2: warning: 'ret' is used uninitialized in
> this function [-Wuninitialized]
> sound/soc/codecs/wm8523.c: In function 'wm8523_probe':
> sound/soc/codecs/wm8523.c:395:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/wm8728.c: In function 'wm8728_probe':
> sound/soc/codecs/wm8728.c:236:2: warning: 'ret' is used uninitialized in
> this function [-Wuninitialized]
> sound/soc/codecs/wm8900.c: In function 'wm8900_probe':
> sound/soc/codecs/wm8900.c:1181:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/wm8903.c: In function 'wm8903_probe':
> sound/soc/codecs/wm8903.c:1907:2: warning: 'ret' is used uninitialized in
> this function [-Wuninitialized]
> sound/soc/codecs/wm8904.c: In function 'wm8904_probe':
> sound/soc/codecs/wm8904.c:2051:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/wm8961.c: In function 'wm8961_probe':
> sound/soc/codecs/wm8961.c:839:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/wm8978.c: In function 'wm8978_probe':
> sound/soc/codecs/wm8978.c:978:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/wm8988.c: In function 'wm8988_probe':
> sound/soc/codecs/wm8988.c:813:22: warning: unused variable 'wm8988'
> [-Wunused-variable]
> sound/soc/codecs/wm8990.c: In function 'wm8990_probe':
> sound/soc/codecs/wm8990.c:1292:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/wm8991.c: In function 'wm8991_probe':
> sound/soc/codecs/wm8991.c:1251:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/wm8996.c: In function 'wm8996_probe':
> sound/soc/codecs/wm8996.c:2679:1: warning: label 'err' defined but not used
> [-Wunused-label]
> sound/soc/codecs/wm9081.c: In function 'wm9081_probe':
> sound/soc/codecs/wm9081.c:1278:2: warning: 'ret' is used uninitialized in
> this function [-Wuninitialized]
> sound/soc/codecs/wm9090.c: In function 'wm9090_probe':
> sound/soc/codecs/wm9090.c:526:6: warning: unused variable 'ret'
> [-Wunused-variable]
> sound/soc/codecs/wm9090.c:525:22: warning: unused variable 'wm9090'
> [-Wunused-variable]
> 
> 
> 

