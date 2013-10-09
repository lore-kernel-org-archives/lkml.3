Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3JIFkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 01:40:51 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46637 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039Ab3JIFkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 01:40:47 -0400
From: Qiao Zhou <zhouqiao@marvell.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <zhangfei.gao@gmail.com>, <linux-kernel@vger.kernel.org>,
        <chao.xie@marvell.com>
CC: Qiao Zhou <zhouqiao@marvell.com>
Subject: [PATCH v1] dma: mmp-tdma: add multiple burst size support for 910-squ
Date: Wed, 9 Oct 2013 13:40:27 +0800
Message-ID: <1381297228-2443-1-git-send-email-zhouqiao@marvell.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-09_01:2013-10-08,2013-10-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=1 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310080193
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1: add multiple burst size support. remove previous fixed 32-byte setting.

Qiao Zhou (1):
  dma: mmp_tdma: add multiple burst size support for 910-squ

 drivers/dma/mmp_tdma.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

