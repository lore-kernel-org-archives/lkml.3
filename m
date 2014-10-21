Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaJUIvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:51:21 -0400
Received: from mailout.micron.com ([137.201.242.129]:15646 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbaJUIvS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:51:18 -0400
From: bpqw <bpqw@micron.com>
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
Subject: [PATCH 1/1] devicetree: bindings: Add vendor prefix for Micron
 Technology Co., Ltd.
Thread-Topic: [PATCH 1/1] devicetree: bindings: Add vendor prefix for Micron
 Technology Co., Ltd.
Thread-Index: Ac/tDA2V70hMLzyhQH+xOy9U8dubsg==
Date: Tue, 21 Oct 2014 08:50:24 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315E745D@NTXXIAMBX02.xacn.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21040.005
X-TM-AS-Result: No--4.014400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is used to add vendor prefix for Micron Technology Inc in the vendor-prefixes.txt file.

Micron Technology, Inc. is an American multinational corporation
based in Boise, Idaho, best known for producing many forms of
semiconductor devices. This includes DRAM, SDRAM, flash memory,
eMMC and SSDs.

Signed-off-by: bean huo <beanhuo@micron.com>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 723999d..a7bbf6e 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -92,6 +92,7 @@ maxim	Maxim Integrated Products
 mediatek	MediaTek Inc.
 micrel	Micrel Inc.
 microchip	Microchip Technology Inc.
+micron	Micron Technology Inc.
 mitsubishi	Mitsubishi Electric Corporation
 mosaixtech	Mosaix Technologies, Inc.
 moxa	Moxa
-- 
1.7.9.5
