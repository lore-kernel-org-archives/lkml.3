Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaI1DX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 23:23:27 -0400
Received: from mga14.intel.com ([192.55.52.115]:60445 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbaI1DXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 23:23:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,612,1406617200"; 
   d="scan'208";a="597819659"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
CC: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Tan, Raymond" <raymond.tan@intel.com>
Subject: RE: [PATCH] SPI: spi-pxa2xx: SPI support for Intel Quark X1000
Thread-Topic: [PATCH] SPI: spi-pxa2xx: SPI support for Intel Quark X1000
Thread-Index: AQHP2ZVZkx0ZBJe9NUiWssulYNYxF5wV4pPw
Date: Sun, 28 Sep 2014 03:23:21 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E99710F@SHSMSX101.ccr.corp.intel.com>
References: <1411752349-31490-1-git-send-email-alvin.chen@intel.com>
	 <1411752349-31490-2-git-send-email-alvin.chen@intel.com>
	 <20140926100832.GE27755@sirena.org.uk>
 <1411741357.22717.4.camel@linux.intel.com>
In-Reply-To: <1411741357.22717.4.camel@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8S3NkO8007779

> 
> >
> > > +/*  see Quark SPI data sheet for implementation rationale */ static
> > > +u32 quark_x1000_set_clk_regvals(u32 rate, u32 *dds, u32 *clk_div) {
> >
> > Please document this in the driver - I don't know if this datasheet is
> > public but even if it is it may not stay that way.
> 
> Datasheet is public.
> I'm just wondering if we can use just a formula instead of table.
> 
As I said before, there are two formulas, but for the given rate, from the formulas, we can get a lot of <dds, clk_div> pairs,
and we also need to select them according to the guidelines which is not formula. The table the datasheet given should be
the best one to meet the jitter and duty cycles as the datasheet documented.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
