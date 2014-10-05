Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaJERZB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:25:01 -0400
Received: from p01c12o144.mxlogic.net ([208.65.145.67]:59406 "EHLO
	p01c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaJERY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:24:58 -0400
X-MXL-Hash: 54317eea3f870be9-da0eee1528e842a946c981e69fde66e05f600c66
X-MXL-Hash: 54317edb6af092fd-95b5514948c66d53983c03f2dbbd256994cbb6af
From: Joe Lawrence <joe.lawrence@stratus.com>
To: <linux-kernel@vger.kernel.org>
CC: <tj@kernel.org>, <paulmck@linux.vnet.ibm.com>, <jiri@resnulli.us>,
        Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v2 0/2] workqueue: add RCU quiescent state between items
Date: Sun, 5 Oct 2014 13:24:20 -0400
Message-ID: <1412529862-17954-1-git-send-email-joe.lawrence@stratus.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [134.111.199.152]
X-AnalysisOut: [v=2.1 cv=U/yGDIbu c=1 sm=1 tr=0 a=VNTQBUOG7PJoPU2GWtE7Ww==]
X-AnalysisOut: [:117 a=VNTQBUOG7PJoPU2GWtE7Ww==:17 a=_KQqW7t0BisA:10 a=Cdz]
X-AnalysisOut: [KgOd8jloA:10 a=BLceEmwcHowA:10 a=uelBKuKpAAAA:8 a=YlVTAMxI]
X-AnalysisOut: [AAAA:8 a=wcWmrNCOSRmO0zbfB7wA:9 a=vppRYCcEzJ8A:10 a=CfWWmC]
X-AnalysisOut: [YVczgA:10 a=mbidY2NB2KEA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014100508); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 - split into two patches: the first inlines the cond_resched_rcu_qs
macro suitable for stable backport, the second converts to using
cond_resched_rcu_qs.

Joe Lawrence (2):
  workqueue: add quiescent state between work items
  workqueue: use cond_resched_rcu_qs macro

 kernel/workqueue.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
1.7.10.4

