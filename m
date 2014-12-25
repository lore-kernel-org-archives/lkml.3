Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaLYGQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 01:16:24 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7022 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788AbaLYGQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 01:16:01 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <sebastian.hesselbarth@gmail.com>,
        <antoine.tenart@free-electrons.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH 0/2] ARM: dts: berlin: enable PMU and add PPI cpu mask to twd interrupts
Date: Thu, 25 Dec 2014 14:12:20 +0800
Message-ID: <1419487942-2277-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-25_03:2014-12-24,2014-12-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1412250071
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the patch enables PMU support to BG2Q and BG2CD SoCs. Another patch
adds the missing PPI cpu mask to twd timer interrupts.

Jisheng Zhang (2):
  ARM: dts: berlin: add pmu node for BG2Q and BG2CD
  ARM: dts: berlin: add PPI cpu mask to twd timer interrupts

 arch/arm/boot/dts/berlin2.dtsi   |  3 ++-
 arch/arm/boot/dts/berlin2cd.dtsi |  8 +++++++-
 arch/arm/boot/dts/berlin2q.dtsi  | 11 ++++++++++-
 3 files changed, 19 insertions(+), 3 deletions(-)

-- 
2.1.4

