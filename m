Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab3JKIYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:24:10 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47691 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757353Ab3JKIYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:24:06 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <linux-kernel@vger.kernel.org>
CC: <haojian.zhuang@gmail.com>, <tglx@linutronix.de>,
        Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH 0/2 v2] add wakeup dt support for irq mmp
Date: Fri, 11 Oct 2013 16:23:56 +0800
Message-ID: <1381479838-7794-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-11_01:2013-10-11,2013-10-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=1
 phishscore=0 adultscore=1 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310110006
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changelog:
V2:
    add the missing head file.

Neil Zhang (2):
  irqchip: mmp: avoid use head file in a specific arch
  irqchip: mmp: add dt support for wakeup

 .../devicetree/bindings/arm/mrvl/intc.txt          |   14 ++-
 drivers/irqchip/irq-mmp.c                          |  126 +++++++++++++++++++-
 include/linux/irqchip/mmp.h                        |   13 ++
 3 files changed, 151 insertions(+), 2 deletions(-)

-- 
1.7.9.5

