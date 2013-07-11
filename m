Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab3GKE4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 00:56:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65181 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab3GKE4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 00:56:07 -0400
X-AuditID: cbfee691-b7fef6d000002d62-a3-51de3ae4a217
From: Chanwoo Choi <cw00.choi@samsung.com>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] power: Fix comment typo in pm_wakeup.h
Date: Thu, 11 Jul 2013 13:55:58 +0900
Message-id: <1373518558-670-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsWyRsSkUPeJ1b1Ag6NHuS2uf3nOanF51xw2
	i8+9Rxgt+hf2MjmwePRtWcXo8WhxC6PH501yAcxRXDYpqTmZZalF+nYJXBmXbxxmKljPUXFi
	T0ID4ze2LkZODgkBE4mFG04wQthiEhfurQeKc3EICSxllPjRu58Jpujun2ksEInpjBLnDrWx
	QziNTBLX+pezgFSxCWhJ7H9xA2ysiAC/xLZ5R1lBbGaBJInza5vAbGEBc4ljE5vBbBYBVYkl
	ixaAbeAVcJaYeOgJ1BlyEh/2PAJbICFwnU1ixe6H7BANAhLfJh8CWsYBlJCV2HSAGaJeUuLg
	ihssExgFFzAyrGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQIDMLT/55N3MF4/4D1IcZkoHET
	maVEk/OBQZxXEm9obGZkYWpiamxkbmlGmrCSOK96i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYm
	Dk6pBkaX9W4MU+ebzjyWqfb3OFtw3dzY+7E+n+X2fWYSOD316KpJcf9cuqR+PzhobL9tl6h8
	94JPdcttGDYvMmHeH7V13tkJmqyCkZt3vDj90trXUujXgVnTs5+x2lfrPbu8c5/I9mtzLqZP
	1bna1ZxUuOi7ceXf5BS9vYyuJuuPWT5/O/e+zmydCt0IJZbijERDLeai4kQA5Jq1P1gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd0nVvcCDfZsYbG4/uU5q8XlXXPY
	LD73HmG06F/Yy+TA4tG3ZRWjx6PFLYwenzfJBTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCtU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jBmXL5xmKlgPUfFiT0JDYzf2LoYOTkkBEwk7v6ZxgJhi0lcuLceKM7FISQw
	nVHi3KE2dginkUniWv9ysCo2AS2J/S9ugHWLCPBLbJt3lBXEZhZIkji/tgnMFhYwlzg2sRnM
	ZhFQlViyaAETiM0r4Cwx8dATRohtchIf9jxin8DIvYCRYRWjaGpBckFxUnqukV5xYm5xaV66
	XnJ+7iZGcIg/k97BuKrB4hCjAAejEg9vQ/zdQCHWxLLiytxDjBIczEoivCenAIV4UxIrq1KL
	8uOLSnNSiw8xJgNtn8gsJZqcD4y/vJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7ZaBwoJpCeWpGan
	phakFsFsYeLglGpgNNf+8Pz9Qx+xbxm/VKOuZ3Ok2/5s4jng5VQsuEVvRdhOjQ3rz74V22bR
	brTL9ZWbyFeTEobmsHdPj0ilN649wvaepZnNgvU3Z3zeC8WAkFXHFwfc+HpyWxfDUa9O/TKu
	H2d3Hjvp8uP6x7DF55c9KGvatUDQQFlIzFLR4H5trd23FRYc1ZxblFiKMxINtZiLihMBk5IL
	6rUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix typo (sorce -> source)

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 include/linux/pm_wakeup.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/pm_wakeup.h b/include/linux/pm_wakeup.h
index 569781f..a0f7080 100644
--- a/include/linux/pm_wakeup.h
+++ b/include/linux/pm_wakeup.h
@@ -36,8 +36,8 @@
  * @last_time: Monotonic clock when the wakeup source's was touched last time.
  * @prevent_sleep_time: Total time this source has been preventing autosleep.
  * @event_count: Number of signaled wakeup events.
- * @active_count: Number of times the wakeup sorce was activated.
- * @relax_count: Number of times the wakeup sorce was deactivated.
+ * @active_count: Number of times the wakeup source was activated.
+ * @relax_count: Number of times the wakeup source was deactivated.
  * @expire_count: Number of times the wakeup source's timeout has expired.
  * @wakeup_count: Number of times the wakeup source might abort suspend.
  * @active: Status of the wakeup source.
-- 
1.8.0

