Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbaCZCX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 22:23:56 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16482 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547AbaCZCXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 22:23:54 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <catalin.marinas@arm.com>, <will.deacon@arm.com>, <rob@landley.net>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] arm64: Fix memory layout typo
Date: Wed, 26 Mar 2014 10:23:21 +0800
Message-ID: <1395800601-17088-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-25_07:2014-03-25,2014-03-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1403250164
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 Documentation/arm64/memory.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
index 5e054bf..c2765e2 100644
--- a/Documentation/arm64/memory.txt
+++ b/Documentation/arm64/memory.txt
@@ -39,7 +39,7 @@ ffffffbffbc00000	ffffffbffbdfffff	   2MB		earlyprintk device
 
 ffffffbffbe00000	ffffffbffbe0ffff	  64KB		PCI I/O space
 
-ffffffbffbe10000	ffffffbcffffffff	  ~2MB		[guard]
+ffffffbffbe10000	ffffffbffbffffff	  ~2MB		[guard]
 
 ffffffbffc000000	ffffffbfffffffff	  64MB		modules
 
-- 
1.7.9.5

