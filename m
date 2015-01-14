Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbbANJg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:36:58 -0500
Received: from mail-bn1on0116.outbound.protection.outlook.com ([157.56.110.116]:32864
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753215AbbANJgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:36:55 -0500
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Jingchang Lu <jingchang.lu@freescale.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 1/2] dmaengine: fsl-edma: add dma memcpy support
Thread-Topic: [PATCH 1/2] dmaengine: fsl-edma: add dma memcpy support
Thread-Index: AQHQJBRBvR5ApUwEo0OF2Mc0BMepuJy/cf2w
Date: Wed, 14 Jan 2015 09:36:52 +0000
Message-ID: <BN3PR0301MB12364CA46991F6616348AD9087410@BN3PR0301MB1236.namprd03.prod.outlook.com>
References: <1419928907-18053-1-git-send-email-jingchang.lu@freescale.com>
 <1419928907-18053-2-git-send-email-jingchang.lu@freescale.com>
In-Reply-To: <1419928907-18053-2-git-send-email-jingchang.lu@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.51]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jingchang.lu@freescale.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN3PR0301MB1235;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1235;
x-forefront-prvs: 04569283F9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(199003)(13464003)(41574002)(51704005)(189002)(77156002)(62966003)(86362001)(76576001)(87936001)(54606007)(2656002)(106116001)(105586002)(106356001)(54206007)(19580405001)(2900100001)(2950100001)(19580395003)(92566002)(66066001)(54356999)(97736003)(46102003)(122556002)(64706001)(33656002)(2501002)(99286002)(74316001)(40100003)(76176999)(50986999)(68736005)(101416001)(102836002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1235;H:BN3PR0301MB1236.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2015 09:36:52.4636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1235
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0E9b48s005293

Hi, Vinod,

   Could you please help review the two patches, and merge them if possible? Thanks!


Best Regards,
Jingchang

>-----Original Message-----
>From: Jingchang Lu [mailto:jingchang.lu@freescale.com]
>Sent: Tuesday, December 30, 2014 4:42 PM
>To: vinod.koul@intel.com
>Cc: dan.j.williams@intel.com; dmaengine@vger.kernel.org; linux-
>kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Lu
>Jingchang-B35083
>Subject: [PATCH 1/2] dmaengine: fsl-edma: add dma memcpy support
>
>This adds the memory copy capability support, the memcpy functionality
>needs to configure the DMAMUX of the channel with the always on slave id.
>
>Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
>---
> drivers/dma/fsl-edma.c | 63
>++++++++++++++++++++++++++++++++++++++++++++++++--
> 1 file changed, 61 insertions(+), 2 deletions(-)

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
