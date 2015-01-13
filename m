Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbbAMGvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 01:51:44 -0500
Received: from mail-by2on0101.outbound.protection.outlook.com ([207.46.100.101]:8448
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750968AbbAMGvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 01:51:42 -0500
From: Peter Chen <Peter.Chen@freescale.com>
To: Huang Rui <ray.huang@amd.com>, Felipe Balbi <balbi@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] usb: gadget: u_uac1: fix build issue
Thread-Topic: [PATCH 1/4] usb: gadget: u_uac1: fix build issue
Thread-Index: AQHQLvltK2p2hX9CMUOt7jMPvV3bB5y9m7+A
Date: Tue, 13 Jan 2015 06:51:40 +0000
Message-ID: <BN3PR0301MB08491E88100625CCAE38DAE781400@BN3PR0301MB0849.namprd03.prod.outlook.com>
References: <1421130034-1891-1-git-send-email-ray.huang@amd.com>
In-Reply-To: <1421130034-1891-1-git-send-email-ray.huang@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.211]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Peter.Chen@freescale.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN3PR0301MB0849;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB0849;
x-forefront-prvs: 045584D28C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(199003)(54606007)(76576001)(97736003)(62966003)(77156002)(68736005)(99286002)(54356999)(86362001)(50986999)(76176999)(46102003)(33656002)(2950100001)(102836002)(106356001)(2900100001)(92566002)(105586002)(106116001)(66066001)(74316001)(101416001)(40100003)(19580405001)(19580395003)(122556002)(64706001)(2656002)(2171001)(87936001)(54206007)(7059030);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB0849;H:BN3PR0301MB0849.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2015 06:51:40.7852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB0849
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0D6ppro025905

 
> See below error message:
>   CC [M]  drivers/gpu/drm/nouveau/core/subdev/vm/nv50.o
>   CC [M]  drivers/staging/lustre/lnet/selftest/module.o
> drivers/usb/gadget/function/f_uac1.c: In function â€˜f_audio_free_instâ€™:
> drivers/usb/gadget/function/f_uac1.c:904:21: error: â€˜struct f_uac1_optsâ€™ has
> no member named â€˜cardâ€™
>   gaudio_cleanup(opts->card);
>                      ^
> make[4]: *** [drivers/usb/gadget/function/f_uac1.o] Error 1
> make[3]: *** [drivers/usb/gadget/function] Error 2
> make[2]: *** [drivers/usb/gadget] Error 2
> make[2]: *** Waiting for unfinished jobs....
>   CC [M]  drivers/staging/lustre/lnet/selftest/ping_test.o
> 
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> Cc: Peter Chen <peter.chen@freescale.com>
> ---
> 

Oh, my three patches have dependencies, it needs to rebase Felipe's fixes tree to fix this problem.

commit 4fde6204df052bb89ba3d915ed6ed9f306f3cfa1
Author: Peter Chen <peter.chen@freescale.com>
Date:   Mon Dec 1 16:09:27 2014 +0800

    usb: gadget: f_uac1: access freed memory at f_audio_free_inst



Peter

 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
