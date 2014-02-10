Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaBJBQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:16:57 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:23189 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbaBJBQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:16:55 -0500
X-AuditID: cbfee68e-b7f566d000002344-75-52f8288685aa
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003901cf25fc$73002790$590076b0$%han@samsung.com>
In-reply-to: <003901cf25fc$73002790$590076b0$%han@samsung.com>
Subject: [PATCH 7/7] pwm: don't use IS_ENABLED(CONFIG_HAVE_PWM)
Date: Mon, 10 Feb 2014 10:16:53 +0900
Message-id: <004001cf25fd$c8a11ff0$59e35fd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8l/GYGhOsBgXmsQoSPhLhnprg0iAAAU7yA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t8zA902jR9BBp8nilhcXniJ1eLyrjls
	FnfvrmK0+LlrHosDi8fOWXfZPfq2rGL0+LxJLoA5issmJTUnsyy1SN8ugStj08GvbAX/WStu
	XHrG3MD4maWLkZNDQsBEomvxH3YIW0ziwr31bCC2kMAyRonmd2UwNbd67gLVcwHFpzNKfHi8
	nBHC+cUo8fb/T7AONgE1iS9fDoNNEhHQl7h0/RIriM0skCgx5/AdRoipthJzG/aD1XAK2EnM
	W/oNrEZYwF6i4fwysBoWAVWJ35dOgtm8QPX/Zz1lgrAFJX5MvscCMVNLYv3O40wQtrzE5jVv
	mbsYOYAuVZd49FcX4gQjiY2blzFDlIhI7HvxDuxmCYFj7BKTNp1mgdglIPFt8iEWiF5ZiU0H
	mCEelpQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchIrzgxt7g0L10vOT93
	EyMkFvt2MN48YH2IMRlo/URmKdHkfGAs55XEGxqbGVmYmpgaG5lbmpEmrCTOu+hhUpCQQHpi
	SWp2ampBalF8UWlOavEhRiYOTqkGxgDl1PyrTO81rXcsWV5wQ2ZV0aqug+v5vl77ez07Yu28
	5TsMXzpJBqdm6R0Ik5G7mOT9Qeg6xz373yFKDCoL9DufPjnJcvTWz1A9dcb3EXynYhPMj2VM
	fXmLr/CaaPiaYtuPp161XbnzrGrGQbW8hM98YRs/qhxyOdOUcE5hnWW7DX9F6q7HakosxRmJ
	hlrMRcWJAA1WpBDbAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jQd02jR9BBk92ClhcXniJ1eLyrjls
	FnfvrmK0+LlrHosDi8fOWXfZPfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzje
	Od7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdonZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd
	35AguB4jAzSQsI4xY9PBr2wF/1krblx6xtzA+Jmli5GTQ0LAROJWz10oW0ziwr31bF2MXBxC
	AtMZJT48Xs4I4fxilHj7/ycbSBWbgJrEly+H2UFsEQF9iUvXL7GC2MwCiRJzDt9hBLGFBGwl
	5jbsB6vhFLCTmLf0G1iNsIC9RMP5ZWA1LAKqEr8vnQSzeYHq/896ygRhC0r8mHyPBWKmlsT6
	nceZIGx5ic1r3jJ3MXIAXaou8eivLsQJRhIbNy9jhigRkdj34h3jBEahWUgmzUIyaRaSSbOQ
	tCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERzrz6R2MK5ssDjEKMDBqMTDu+PP9yAh
	1sSy4srcQ4wSHMxKIrwv7wKFeFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0OR+YhvJK4g2NTcyM
	LI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgfHMuVnlX971Lnsa9bTMRFCp
	NsFy2tKvYVz3r9kdn6pQnCC3Ycu61Wf//ktZHtG2bXkuX1b/SeWtp0MF2ROmV7HPbwrkKj7D
	feUTW5jN7jXnLTO7/oTvTfrZxdR24t50j68RnWtvOBxKYfqUe/69zdyqIEETf7Pts9KC97uJ
	BH41r3y712+beIMSS3FGoqEWc1FxIgAlkhvvOQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HAVE_PWM symbol is only for legacy platforms that provide
the PWM API without using the generic framework. However, legacy
PWM drivers were already moved to the generic PWM framework.
Thus, HAVE_PWM should be removed, because HAVE_PWM is not
required anymore.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 include/linux/pwm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index f0feafd..4717f54 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -7,7 +7,7 @@
 struct pwm_device;
 struct seq_file;
 
-#if IS_ENABLED(CONFIG_PWM) || IS_ENABLED(CONFIG_HAVE_PWM)
+#if IS_ENABLED(CONFIG_PWM)
 /*
  * pwm_request - request a PWM device
  */
-- 
1.7.10.4


