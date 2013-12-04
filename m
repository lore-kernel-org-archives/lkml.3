Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3LDIVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:21:23 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28449 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754383Ab3LDIVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:21:21 -0500
From: Qiao Zhou <zhouqiao@marvell.com>
To: <eric.y.miao@gmail.com>, <haojian.zhuang@gmail.com>,
        <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <chao.xie@marvell.com>
CC: Qiao Zhou <zhouqiao@marvell.com>
Subject: [PATCH 0/2 V1] arm-mmp-build-sram-driver-alone
Date: Wed, 4 Dec 2013 16:21:13 +0800
Message-ID: <1386145275-27438-1-git-send-email-zhouqiao@marvell.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.72,1.0.14,0.0.0000
 definitions=2013-12-04_03:2013-12-03,2013-12-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1312040003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V1 -> V0:
No need for help text for MMP_SRAM in Kconfig and move it into MMP_TDMA
text in Kconfig.

Qiao Zhou (2):
  arm: mmp: build sram driver alone
  dma: mmp-tdma: select sram driver

 arch/arm/mach-mmp/Kconfig  |    3 +++
 arch/arm/mach-mmp/Makefile |    3 ++-
 drivers/dma/Kconfig        |    2 ++
 3 files changed, 7 insertions(+), 1 deletions(-)

