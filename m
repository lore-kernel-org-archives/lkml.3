Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab3BRFQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:16:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:57176 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3BRFQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:16:39 -0500
X-AuditID: cbfee691-b7f556d000001a24-63-5121b937ef7c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000201ce0d96$9fa550b0$deeff210$%han@samsung.com>
In-reply-to: <000201ce0d96$9fa550b0$deeff210$%han@samsung.com>
Subject: [PATCH 4/5 RESEND] video: s3c-fb: add the bit definitions for CSC
 EQ709 and EQ601
Date: Mon, 18 Feb 2013 14:16:38 +0900
Message-id: <000501ce0d97$21294a60$637bdf20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Nlp93iQLgxtgRRimJ2C2xwhxUfAAAFwPg
Content-language: ko
x-cr-hashedpuzzle: Abil BWew EWhB Fg0M Lgo7 SN1T SOJr VutY XU69 YlRI jvY3 k+tP
 lqBI qgPC wKNZ
 z9D2;5;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGYAbABvAHIAaQBhAG4AcwBjAGgAYQBuAGQAaQBuAGEAdABAAGcAbQB4AC4AZABlADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGYAYgBkAGUAdgBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{F4AC0811-E216-4A64-9C19-F03266F72D5D};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 18 Feb 2013 05:16:30
 GMT;WwBQAEEAVABDAEgAIAA0AC8ANQAgAFIARQBTAEUATgBEAF0AIAB2AGkAZABlAG8AOgAgAHMAMwBjAC0AZgBiADoAIABhAGQAZAAgAHQAaABlACAAYgBpAHQAIABkAGUAZgBpAG4AaQB0AGkAbwBuAHMAIABmAG8AcgAgAEMAUwBDACAARQBRADcAMAA5ACAAYQBuAGQAIABFAFEANgAwADEA
x-cr-puzzleid: {F4AC0811-E216-4A64-9C19-F03266F72D5D}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zA13znYqBBqsWMFmc6PvAanF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKOvWxjK1jNVjGxewdjA+M01i5GTg4JAROJv7tPsUHY
	YhIX7q0Hsrk4hASWMUr0X1kAV/T/RQcrRGIRo8SW8yvZIZxfjBLP2k+wgFSxCahJfPlyGCjB
	wSEioC/R1qIBUsMsMJdR4tKaI2A1QgK2Ep0vToLZnAJ2EvMunWIGsYUFYiRau86xg9gsAqoS
	Z4/+BNvMC1R/5t51NghbUOLH5HtgvcwCWhLrdx5ngrDlJTavecsMsldCQF3i0V9dkLCIgJHE
	vfkQrcwCIhL7XrxjBLlHQmABm8S86W+ZIT4zlVj/cDNU4hS7RMOc7UwQRwhIfJt8iAViqKzE
	pgNQ9ZISB1fcYJnAKDULyUmzkJw0C8lJs5DsXsDIsopRNLUguaA4Kb3IVK84Mbe4NC9dLzk/
	dxMjJC4n7mC8f8D6EGMy0PqJzFKiyfnAuM4riTc0NjYxMzE1Mbc0NTclTVhJnFf+kkygkEB6
	YklqdmpqQWpRfFFpTmrxIUYmDk6pBsZFG3qkl58QfvbrdmnFTZ0wwV+sN9R2KHIk7jDVet8h
	eUIsqT0uyOepitfhDxm+HFPqS8TetPOHzH+9TNlMd7HVZa0cS/11l8OO1RSeyE1Je7psWf4S
	no+Taz64Be/YznTM4vmGTZMrcqJC5wW8W8onJM9m1N9y1HHKlhUHfcq3TVZ79v1djowSS3FG
	oqEWc1FxIgAcgQ4W4QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAV2znYqBBi8WW1uc6PvAanF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzjr1sYytYzVYx
	sXsHYwPjNNYuRk4OCQETif8vOqBsMYkL99azdTFycQgJLGKU2HJ+JTuE84tR4ln7CRaQKjYB
	NYkvXw4DJTg4RAT0JdpaNEBqmAXmMkpcWnMErEZIwFai88VJMJtTwE5i3qVTzCC2sECMRGvX
	OXYQm0VAVeLs0Z9gm3mB6s/cu84GYQtK/Jh8D6yXWUBLYv3O40wQtrzE5jVvmUH2SgioSzz6
	qwsSFhEwkrg3H6KVWUBEYt+Ld4wg90gILGCTmDf9LTPEZ6YS6x9uZpzAKDILyYpZSFbMQrJi
	FpJZCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER/0z6R2MqxosDjEKcDAq8fAy5CsG
	CrEmlhVX5h5ilOBgVhLh3SQCFOJNSaysSi3Kjy8qzUktPsSYDAyBicxSosn5wISUVxJvaGxi
	ZmRpZGZhZGJuTpqwkjgv46knAUIC6YklqdmpqQWpRTBbmDg4pRoYFX5v+Xvw1yRLvnrXPR0T
	u4VqcrWZ26a1PpP7I3BQO/zJohldzm7/GsVXM+35eeHlYkONE3Mr3hfVqAXwbntpsv73gtU3
	vy9zUJlXwL57lerC9T4Ks07uvvPvhcisgwt90p73X4jy/3pe9WyE/YnF+ov2yrz8eOU/Q9Lb
	6PfRs1me3NSf77FM/qwSS3FGoqEWc1FxIgCnmsMWPgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the bit definitions for CSC EQ709 and EQ601.
These definitons are used to control the CSC parameter such as
equation 709 and equation 601.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 include/video/samsung_fimd.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/video/samsung_fimd.h b/include/video/samsung_fimd.h
index be7b853..2f95d9a 100644
--- a/include/video/samsung_fimd.h
+++ b/include/video/samsung_fimd.h
@@ -176,6 +176,8 @@
 /* WINCONx */
 
 #define WINCON(_win)				(0x20 + ((_win) * 4))
+#define WINCONx_CSCCON_EQ601			(0x0 << 28)
+#define WINCONx_CSCCON_EQ709			(0x1 << 28)
 #define WINCONx_CSCWIDTH_MASK			(0x3 << 26)
 #define WINCONx_CSCWIDTH_SHIFT			26
 #define WINCONx_CSCWIDTH_WIDE			(0x0 << 26)
-- 
1.7.2.5


