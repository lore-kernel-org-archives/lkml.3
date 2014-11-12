Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaKLO1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:27:22 -0500
Received: from mailout.micron.com ([137.201.242.129]:34011 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaKLO1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:27:20 -0500
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
Subject: [V3 PATCH 1/1] devicetree: bindings: Add vendor prefix for Micron
 Technology Co., Ltd.
Thread-Topic: [V3 PATCH 1/1] devicetree: bindings: Add vendor prefix for
 Micron Technology Co., Ltd.
Thread-Index: AQHP/oSu1Bl91pDU+Ei2zIe8Emp/lw==
Date: Wed, 12 Nov 2014 14:26:42 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315EB8F8@NTXXIAMBX02.xacn.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21094.007
X-TM-AS-Result: No--3.871600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is used to add vendor prefix for Micron Technology Inc in the
vendor-prefixes.txt file.

Micron Technology,Inc.is an American multinational corporation based in Boise,
Idaho,best known for producing many forms of semiconductor devices.This includes
DRAM,SDRAM,flash memory,eMMC and SSDs.

Signed-off-by: Bean Huo <bpqw@micron.com>
---
V2:
  - Add signed-off-by
  - Modify commit logs that wrapped to less than 80 columns
V3:
  - Remove the same signed-off-by owner's mailbox
  - Modify proper name of signed-off-by 

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
