Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbbADPTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 10:19:06 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22235 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbbADPTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 10:19:01 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <chris@printf.net>, <ulf.hansson@linaro.org>
CC: <peter.griffin@linaro.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH next 0/2] mmc: sdhci-pxav3: fix unbalanced pm and clock issues
Date: Sun, 4 Jan 2015 23:15:46 +0800
Message-ID: <1420384548-7816-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-04_03:2015-01-02,2015-01-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1501040160
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches fix unbalanced pm and clock issues. The clock unbalance
issue would cause power consumption regression because the clock will never
be gated at runtime PM suspend.

Jisheng Zhang (2):
  mmc: sdhci-pxav3: fix unbalanced clock issues during probe
  mmc: sdhci-pxav3: fix pm unbalanced issue in -> remove()

 drivers/mmc/host/sdhci-pxav3.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

-- 
2.1.4

