Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbbAOIlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:41:55 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41852 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbbAOIlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:41:51 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-97-54b77d47c8a9
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Kukjin Kim <kgene@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 0/3] ARM: dts: Regulator changes and fuel gauge for
 exynos4412-trats2
Date: Thu, 15 Jan 2015 09:41:32 +0100
Message-id: <1421311295-18960-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIJMWRmVeSWpSXmKPExsVy+t/xq7rutdtDDJ6t5reYf+Qcq8XrF4YW
	/Y9fM1tsenyN1eLyrjlsFjPO72NyYPPYtKqTzWPzknqPvi2rGD0+b5ILYInisklJzcksSy3S
	t0vgyli35A1zwUm2iinH37I2MG5g7WLk4JAQMJE4ON+1i5ETyBSTuHBvPVsXIxeHkMBSRonb
	Rz+xQjh9TBL3DsxmAaliEzCW2Lx8CRuILSKwglHiYpMliM0sYCjx890fdhBbWCBcYvPVOawg
	NouAqkTz5+fMIDavgLvEk76rLBDb5CROHpvMOoGRewEjwypG0dTS5ILipPRcQ73ixNzi0rx0
	veT83E2MkGD4soNx8TGrQ4wCHIxKPLwMfttDhFgTy4orcw8xSnAwK4nwduYAhXhTEiurUovy
	44tKc1KLDzEycXBKNTCuDJil01RlbNgdk3Bm4TzmD05MCwv2RL9m8H2k5fF0Yntf5KFPz8Ie
	vZjq/bblXOCJh2t6j62fu/TDG9Ww+o9ntycoNfR6CO9VcPJ4+C5WLYZjx/lr3xW/Pc43nNvf
	8pR9h4xMSkPRsUjzyTsfuy6o1q+5WrxjjeKtKJ2nbxoMn3POlwryXVqnxFKckWioxVxUnAgA
	hnbZ0eQBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,


I grouped into one patchset already posted patches for Trats2 board:
1. Fuel gauge:
   https://lkml.org/lkml/2015/1/7/167
2. Suspend configuration for max77686 regulators:
   https://lkml.org/lkml/2014/10/29/262
3. GPIO control for max77686 regulators:
   https://lkml.org/lkml/2015/1/5/230


The necessary changes in max77686 regulator driver were already
applied by Mark Brown.

Best regards,
Krzysztof


Krzysztof Kozlowski (3):
  ARM: dts: exynos4412-trats2: Add Maxim 77693 fuel gauge node
  ARM: dts: exynos4412-trats2: Add suspend configuration for max77686
    regulators
  ARM: dts: exynos4412-trats: Switch max77686 regulators to GPIO control

 arch/arm/boot/dts/exynos4412-trats2.dts | 115 ++++++++++++++++++--------------
 1 file changed, 65 insertions(+), 50 deletions(-)

-- 
1.9.1

