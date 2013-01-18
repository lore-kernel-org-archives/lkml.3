Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab3ARDlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:41:22 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41870 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab3ARDlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:41:21 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] regulator: lp872x: Remove _rdev_to_offset() function
Thread-Topic: [PATCH] regulator: lp872x: Remove _rdev_to_offset() function
Thread-Index: AQHN9SO7Dwfv+t3ggE6IGMpb4nlTIJhOb87A
Date: Fri, 18 Jan 2013 03:41:10 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E1A8E0@DQHE02.ent.ti.com>
References: <1358476199.25899.3.camel@phoenix>
In-Reply-To: <1358476199.25899.3.camel@phoenix>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.78]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0I3fNkM001722

> There is only one caller calling _rdev_to_offset(), and the code
> looks simper if we remove _rdev_to_offset(). Thus remove it.

Acked-by: Milo Kim <milo.kim@ti.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
