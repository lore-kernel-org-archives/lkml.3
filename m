Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353Ab3DAXH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 19:07:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36150 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757870Ab3DAXH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 19:07:57 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] regulator: lp8788: Remove lp8788_dldo_id and
 lp8788_aldo_id arrays
Thread-Topic: [PATCH 1/2] regulator: lp8788: Remove lp8788_dldo_id and
 lp8788_aldo_id arrays
Thread-Index: AQHOLu1Ti11+EiY3ekGAq3BoioYuqpjB/CbQ
Date: Mon, 1 Apr 2013 23:07:45 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E4A7BB@DQHE02.ent.ti.com>
References: <1364829984.17176.1.camel@phoenix>
In-Reply-To: <1364829984.17176.1.camel@phoenix>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.62]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r31N7xfr013554

> The id for DLDOx matches the entries in enum lp8788_ldo_id and it's
> easy to
> calculate the id for ALDOx. Thus remove lp8788_dldo_id and
> lp8788_aldo_id
> arrays.

Both patches look good, thanks!

Acked-by: Milo Kim <milo.kim@ti.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
