Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbaEGIg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:36:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55612 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaEGIg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:36:56 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-d3-5369f0a12ead
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Simon Baatz'" <gmbnomis@gmail.com>
References: <020f01cf69ce$bf617b50$3e2471f0$%han@samsung.com>
In-reply-to: <020f01cf69ce$bf617b50$3e2471f0$%han@samsung.com>
Subject: [PATCH 4/5] rtc: rtc-mv: Make of_device_id array const
Date: Wed, 07 May 2014 17:36:48 +0900
Message-id: <021501cf69cf$7cb558c0$76200a40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9pzr9CTHGzqjsGTXmFpMFJp7KU/wAAIirw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zY92FHzKDDR784bJYcvEqu8Wc9WvY
	LE7u2sZqcXnhJSCxaw6bxf7ODkYHNo+ds+6ye+yZeJLN48SM3ywefVtWMXpMn/eTyePzJrkA
	tigum5TUnMyy1CJ9uwSujIfXb7AXzGCt2LL5LVsD4yKWLkZODgkBE4n3Ww9B2WISF+6tZ+ti
	5OIQEljGKHF09VRGmKJLLXdZIRKLGCVurdjNDuH8ZpTY0f+LDaSKTUBN4suXw0AJDg4RAX2J
	thYNkBpmgc2MEtuOHgKbJCRgK7G2+StYPaeAncTkI1PZQWxhAXuJF9snsoH0sgioSjxeaQES
	5gUqf/IeopxXQFDix+R7YJcyC2hJrN95nAnClpfYvOYtM0irhIC6xKO/uiBhEQEjidXPjkCV
	iEjse/GOEeQcCYGP7BIXf98GS7AICEh8mwzyPUivrMSmA8wQ/0pKHFxxg2UCo8QsJJtnIdk8
	C8nmWUhWLGBkWcUomlqQXFCclF5kqFecmFtcmpeul5yfu4kREr29OxhvH7A+xJgMtH4is5Ro
	cj4w+vNK4g2NzYwsTE1MjY3MLc1IE1YS5016mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1Oq
	gXGiB19L9VaWW4eWc26Z5vmBXbA8bYaP8uHHaySXuOR7+1ZfWMT65tq9sN3dxYb/czr3bpqZ
	FRNZI7OuTvxK62EPvTotxhXqPsK5n64ujzt7/5V1QPM6i8Rj7z3Da+cI6wv1xcinnFYoNlu1
	MNphc3LGpuSDXBfnPLi9+/qfHeHuCY7XjSr3TFJiKc5INNRiLipOBADIn9c/9AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAd2FHzKDDZ72slssuXiV3WLO+jVs
	Fid3bWO1uLzwEpDYNYfNYn9nB6MDm8fOWXfZPfZMPMnmcWLGbxaPvi2rGD2mz/vJ5PF5k1wA
	W1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0B1K
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoyH12+wF8xgrdiy+S1bA+Mi
	li5GTg4JAROJSy13WSFsMYkL99azdTFycQgJLGKUuLViNzuE85tRYkf/LzaQKjYBNYkvXw4D
	JTg4RAT0JdpaNEBqmAU2M0psO3qIEaRGSMBWYm3zV7B6TgE7iclHprKD2MIC9hIvtk9kA+ll
	EVCVeLzSAiTMC1T+5D1EOa+AoMSPyffAjmMW0JJYv/M4E4QtL7F5zVtmkFYJAXWJR391QcIi
	AkYSq58dgSoRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqX
	rpecn7uJEZwanknvYFzVYHGIUYCDUYmH1+JtRrAQa2JZcWXuIUYJDmYlEd5dFzODhXhTEiur
	Uovy44tKc1KLDzEmA/05kVlKNDkfmLbySuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliS
	mp2aWpBaBLOFiYNTqoEx6Karn476fd9L/RyVijdrnuWd8HRssM3VCksWl3TZEHPpyoI7O1cc
	/qLxw+RryrM/pVYn9qUITrjGLLRh1+nuiUolr+5vCNTabTvtwH1Li9suvdN2HUp/c97oR8E8
	N6vpFX86Lm/qzErXlwj9sCv5dPpufwUdx2Pcmwu+7mDRODBF5+G2q4nvlViKMxINtZiLihMB
	uS3S7FEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions
handle it as const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-mv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-mv.c b/drivers/rtc/rtc-mv.c
index d15a999..6aaec2f 100644
--- a/drivers/rtc/rtc-mv.c
+++ b/drivers/rtc/rtc-mv.c
@@ -319,7 +319,7 @@ static int __exit mv_rtc_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_OF
-static struct of_device_id rtc_mv_of_match_table[] = {
+static const struct of_device_id rtc_mv_of_match_table[] = {
 	{ .compatible = "marvell,orion-rtc", },
 	{}
 };
-- 
1.7.10.4


