Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaJ0Ipi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:45:38 -0400
Received: from mailout.micron.com ([137.201.242.129]:45981 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbaJ0Ipg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:45:36 -0400
From: bpqw <bpqw@micron.com>
To: Rafal Milecki <zajec5@gmail.com>
CC: Marek Vasut <marex@denx.de>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "grmoore@altera.com" <grmoore@altera.com>,
        Brian Norris <computersforpeace@gmail.com>,
        "shijie8@gmail.com" <shijie8@gmail.com>
Subject: RE: [PATCH 1/1 v2] driver:mtd:spi-nor:fix spi_nor_scan overwrite
 platform ID point
Thread-Topic: [PATCH 1/1 v2] driver:mtd:spi-nor:fix spi_nor_scan overwrite
 platform ID point
Thread-Index: AQHP7cbEERDTsMxUkU+Be0a8ZGno35xDpsbw
Date: Mon, 27 Oct 2014 08:44:49 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315E8808@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315E62CB@NTXXIAMBX02.xacn.micron.com>
	<201410150045.53976.marex@denx.de>
	<A765B125120D1346A63912DDE6D8B6315E6D82@NTXXIAMBX02.xacn.micron.com>
 <CACna6rxGzOVu+PKFxHeD7fnhG__3kcM-vY=q8OgtSVgZuQzGwA@mail.gmail.com>
In-Reply-To: <CACna6rxGzOVu+PKFxHeD7fnhG__3kcM-vY=q8OgtSVgZuQzGwA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-21056.005
x-tm-as-result: No--32.466400-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9R8jh0E004693

Hi,rafal

Maybe this patch is not very reasonable.But for fix this case,I will develop a new  patch that
is just used to add extended ID for micron spi nor in the spi_nor_ids[].
Thanks for your review my patch.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
