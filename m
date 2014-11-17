Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaKQGQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 01:16:16 -0500
Received: from mailout.micron.com ([137.201.242.129]:49033 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaKQGQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 01:16:14 -0500
From: =?iso-2022-jp?B?QmVhbiBIdW8gGyRCcDlJTElMGyhCIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
CC: Jason Cooper <jason@lakedaemon.net>, Mark Brown <broonie@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, Thierry Reding <treding@nvidia.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Andrew Lunn <andrew@lunn.ch>, Silvio F <silvio.fricke@gmail.com>,
        Hayato Suzuki <hytszk@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE:  [V3 PATCH 1/1] devicetree: bindings: Add vendor prefix for
 Micron Technology Co., Ltd.
Thread-Topic: [V3 PATCH 1/1] devicetree: bindings: Add vendor prefix for
 Micron Technology Co., Ltd.
Thread-Index: Ac/tDA2V70hMLzyhQH+xOy9U8dubsgBjfqCwACJUHlAAlaGE0AF90TiwAC+lVYABlPI+sADp3ILw
Date: Mon, 17 Nov 2014 06:15:24 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315EC3BF@NTXXIAMBX02.xacn.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-21108.004
x-tm-as-result: No--33.049100-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>This patch is used to add vendor prefix for Micron Technology
>Inc in the vendor-prefixes.txt file.

>Micron Technology,Inc.is an American multinational corporation 
>based in Boise, Idaho,best known for producing many forms of
>semiconductor devices.This includes DRAM,SDRAM,flash memory,
>eMMC and SSDs.

>Signed-off-by: Bean Huo <bpqw@micron.com>
>---
>V2:
>  - Add signed-off-by
>  - Modify commit logs that wrapped to less than 80 columns
>V3:
>  - Remove the same signed-off-by owner's mailbox
>  - Modify proper name of signed-off-by 

Hi,
Who can tell me how about this simple patch that only add our Micron vendor,
in case appear warning,while check your patch with checkpatch.pl
just as this patch: http://lists.infradead.org/pipermail/linux-mtd/2014-October/055776.html

