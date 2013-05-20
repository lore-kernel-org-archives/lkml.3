Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab3ETJG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:06:27 -0400
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:15838
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733Ab3ETJGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:06:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zcb8kzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <grant.likely@linaro.org>
CC: <rob.herring@calxeda.com>, <arnd@arndb.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <shawn.guo@linaro.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH 4/6] ARM: dts: imx6q: add pinctrl for WEIM NOR
Date: Mon, 20 May 2013 16:49:00 +0800
Message-ID: <1369039742-10893-5-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1369039742-10893-1-git-send-email-b32955@freescale.com>
References: <1369039742-10893-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pinctrl for WEIM nor.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 arch/arm/boot/dts/imx6q.dtsi |   58 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index ed11bcf..e6174c7 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -323,6 +323,64 @@
 						>;
 					};
 				};
+
+				weim {
+					pinctrl_weim_nor_1: weim_norgrp-1 {
+						fsl,pins = <
+							MX6Q_PAD_EIM_OE__EIM_OE_B     0x10
+							MX6Q_PAD_EIM_RW__EIM_RW       0x10
+							MX6Q_PAD_EIM_CS0__EIM_CS0_B   0x10
+							MX6Q_PAD_EIM_LBA__EIM_LBA_B   0x10
+							MX6Q_PAD_EIM_WAIT__EIM_WAIT_B 0x8000
+							MX6Q_PAD_EIM_BCLK__EIM_BCLK   0x8000
+
+							/* data */
+							MX6Q_PAD_EIM_D16__EIM_DATA16 0x1b0b0
+							MX6Q_PAD_EIM_D17__EIM_DATA17 0x1b0b0
+							MX6Q_PAD_EIM_D18__EIM_DATA18 0x1b0b0
+							MX6Q_PAD_EIM_D19__EIM_DATA19 0x1b0b0
+							MX6Q_PAD_EIM_D20__EIM_DATA20 0x1b0b0
+							MX6Q_PAD_EIM_D21__EIM_DATA21 0x1b0b0
+							MX6Q_PAD_EIM_D22__EIM_DATA22 0x1b0b0
+							MX6Q_PAD_EIM_D23__EIM_DATA23 0x1b0b0
+							MX6Q_PAD_EIM_D24__EIM_DATA24 0x1b0b0
+							MX6Q_PAD_EIM_D25__EIM_DATA25 0x1b0b0
+							MX6Q_PAD_EIM_D26__EIM_DATA26 0x1b0b0
+							MX6Q_PAD_EIM_D27__EIM_DATA27 0x1b0b0
+							MX6Q_PAD_EIM_D28__EIM_DATA28 0x1b0b0
+							MX6Q_PAD_EIM_D29__EIM_DATA29 0x1b0b0
+							MX6Q_PAD_EIM_D30__EIM_DATA30 0x1b0b0
+							MX6Q_PAD_EIM_D31__EIM_DATA31 0x1b0b0
+
+							/* address */
+							MX6Q_PAD_EIM_A23__EIM_ADDR23 0xb0b1
+							MX6Q_PAD_EIM_A22__EIM_ADDR22 0xb0b1
+							MX6Q_PAD_EIM_A21__EIM_ADDR21 0xb0b1
+							MX6Q_PAD_EIM_A20__EIM_ADDR20 0xb0b1
+							MX6Q_PAD_EIM_A19__EIM_ADDR19 0xb0b1
+							MX6Q_PAD_EIM_A18__EIM_ADDR18 0xb0b1
+							MX6Q_PAD_EIM_A17__EIM_ADDR17 0xb0b1
+							MX6Q_PAD_EIM_A16__EIM_ADDR16 0xb0b1
+							MX6Q_PAD_EIM_DA15__EIM_AD15  0xb0b1
+							MX6Q_PAD_EIM_DA14__EIM_AD14  0xb0b1
+							MX6Q_PAD_EIM_DA13__EIM_AD13  0xb0b1
+							MX6Q_PAD_EIM_DA12__EIM_AD12  0xb0b1
+							MX6Q_PAD_EIM_DA11__EIM_AD11  0xb0b1
+							MX6Q_PAD_EIM_DA10__EIM_AD10  0xb0b1
+							MX6Q_PAD_EIM_DA9__EIM_AD09   0xb0b1
+							MX6Q_PAD_EIM_DA8__EIM_AD08   0xb0b1
+							MX6Q_PAD_EIM_DA7__EIM_AD07   0xb0b1
+							MX6Q_PAD_EIM_DA6__EIM_AD06   0xb0b1
+							MX6Q_PAD_EIM_DA5__EIM_AD05   0xb0b1
+							MX6Q_PAD_EIM_DA4__EIM_AD04   0xb0b1
+							MX6Q_PAD_EIM_DA3__EIM_AD03   0xb0b1
+							MX6Q_PAD_EIM_DA2__EIM_AD02   0xb0b1
+							MX6Q_PAD_EIM_DA1__EIM_AD01   0xb0b1
+							MX6Q_PAD_EIM_DA0__EIM_AD00   0xb0b1
+						>;
+					};
+
+				};
 			};
 		};
 
-- 
1.7.1


