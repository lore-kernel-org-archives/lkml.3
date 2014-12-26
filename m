Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbaLZJCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 04:02:14 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30759 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315AbaLZJBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 04:01:52 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <sebastian.hesselbarth@gmail.com>,
        <antoine.tenart@free-electrons.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH v2 0/3] ARM: dts: berlin: add PMU and twd's cpu mask and fix GPIO locations
Date: Fri, 26 Dec 2014 16:57:58 +0800
Message-ID: <1419584281-4811-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-25_06:2014-12-24,2014-12-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1412260098
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches try to improve dts for berlin. One of them enables PMU support
to BG2Q and BG2CD SoCs. One of them adds the missing PPI cpu mask to twd timer
interrupts. The last one corrects the SM GPIOs' location for BG2Q SoC.

Changes since v1:
 - Adds some text to the log of the second commit
 - Adds the patch to fix SM GPIO locations

Jisheng Zhang (3):
  ARM: dts: berlin: add pmu node for BG2Q and BG2CD
  ARM: dts: berlin: add PPI cpu mask to twd timer interrupts
  ARM: dts: berlin: correct BG2Q's SM GPIO location.

 arch/arm/boot/dts/berlin2.dtsi   |  2 +-
 arch/arm/boot/dts/berlin2cd.dtsi |  7 +++-
 arch/arm/boot/dts/berlin2q.dtsi  | 70 ++++++++++++++++++++++------------------
 3 files changed, 46 insertions(+), 33 deletions(-)

-- 
2.1.4

