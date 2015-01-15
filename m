Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbbAOJ6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:58:45 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:41639 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbbAOJ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 04:58:43 -0500
From: Kaixu Xia <xiakaixu@huawei.com>
To: <mathieu.poirier@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <xiakaixu@huawei.com>, <kaixu.xia@linaro.org>
Subject: [PATCH] coresight: fix the debug AMBA bus name
Date: Thu, 15 Jan 2015 17:49:45 +0800
Message-ID: <1421315385-79209-1-git-send-email-xiakaixu@huawei.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.54B78E87.00BE,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: d98fa41d73410c9b31b0416f31eb88b5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The right debug AMBA bus name should be APB(Advanced Peripheral Bus),
so just fix it.

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
---
 Documentation/trace/coresight.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace/coresight.txt b/Documentation/trace/coresight.txt
index bba7dbf..0236155 100644
--- a/Documentation/trace/coresight.txt
+++ b/Documentation/trace/coresight.txt
@@ -46,7 +46,7 @@ At typical coresight system would look like this:
   | |   .        | !   | |   .        | !      | !        .   |      | SWD/
   | |   .        | !   | |   .        | !      | !        .   |      | JTAG
   *****************************************************************<-|
- *************************** AMBA Debug ABP ************************
+ *************************** AMBA Debug APB ************************
   *****************************************************************
    |    .          !         .          !        !        .    |
    |    .          *         .          *        *        .    |
@@ -79,7 +79,7 @@ At typical coresight system would look like this:
           To trace port                       TPIU= Trace Port Interface Unit
                                               SWD = Serial Wire Debug
 
-While on target configuration of the components is done via the ABP bus,
+While on target configuration of the components is done via the APB bus,
 all trace data are carried out-of-band on the ATB bus.  The CTM provides
 a way to aggregate and distribute signals between CoreSight components.
 
-- 
1.8.5.5

