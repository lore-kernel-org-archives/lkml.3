Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab3JKBHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:07:46 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44046 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755763Ab3JKBHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:07:44 -0400
From: Qiao Zhou <zhouqiao@marvell.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <chao.xie@marvell.com>,
        <zhangfei.gao@gmail.com>
CC: Qiao Zhou <zhouqiao@marvell.com>
Subject: [PATCH v2] dma: mmp-tdma: add multiple burst size support for 910-squ
Date: Fri, 11 Oct 2013 09:07:00 +0800
Message-ID: <1381453621-5382-1-git-send-email-zhouqiao@marvell.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-10_06:2013-10-10,2013-10-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=4 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310100126
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1: add multiple burst size support. remove previous fixed 32-byte setting.
v2: correct some missing definition.

Qiao Zhou (1):
  dma: mmp_tdma: add multiple burst size support for 910-squ

 drivers/dma/mmp_tdma.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

