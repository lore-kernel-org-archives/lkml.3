Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3KGDTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 22:19:03 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42961 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753899Ab3KGDS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 22:18:58 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <rob.herring@calxeda.com>, <linux@arm.linux.org.uk>,
        <kernel@pengutronix.de>, <baohua@kernel.org>, <dinguyen@altera.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH V2 0/4] arm: make use of common scu_a9_get_base() interface
Date: Thu, 7 Nov 2013 11:16:40 +0800
Message-ID: <1383794204-4714-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-07_01:2013-11-06,2013-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=1 spamscore=1 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311060263
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e9d6b3358ac35901ccc6a4a5a317670fa469db25 adds common APIs to
get scu base address from CP15. This patch series connverts some platforms
to use that interface.

Jisheng Zhang (4):
  arm: highbank: make use of common scu_a9_get_base() interface
  arm: imx: make use of common scu_a9_get_base() interface
  arm: prima2: make use of common scu_a9_get_base() interface
  arm: socfgpa: make use of common scu_a9_get_base() interface

 arch/arm/mach-highbank/highbank.c | 4 ++--
 arch/arm/mach-imx/platsmp.c       | 3 +--
 arch/arm/mach-prima2/platsmp.c    | 3 +--
 arch/arm/mach-socfpga/socfpga.c   | 4 ++--
 4 files changed, 6 insertions(+), 8 deletions(-)

-- 
1.8.4.2

