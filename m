Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaAHBE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 20:04:57 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:49408 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbaAHBEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 20:04:49 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-f5-52cca430aec0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Balaji T K'" <balajitk@ti.com>,
        "'Nishanth Menon'" <nm@ti.com>
References: <002001cf0c0d$461abfa0$d2503ee0$%han@samsung.com>
In-reply-to: <002001cf0c0d$461abfa0$d2503ee0$%han@samsung.com>
Subject: [PATCH 3/3] regulator: twl: Fix checkpatch issue
Date: Wed, 08 Jan 2014 10:04:48 +0900
Message-id: <002201cf0c0d$a0a7e6a0$e1f7b3e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8MDUYAj2m3DqtwQ9mZHqZTKqWOEAAAClfw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t8zA12DJWeCDO6tMLWYOnk7m8XUh0/Y
	LC4vvMRq8e1KB5PF5V1z2Cze/DjL5MDmsXPWXXaPTas62Tz6tqxi9Dh+YzuTx+dNcgGsUVw2
	Kak5mWWpRfp2CVwZd5qKCpZzVHz6fpilgfERWxcjJ4eEgInE6ievmSFsMYkL99YDxbk4hASW
	MUpsOfyYFabow8lD7BCJRYwSi+Y1Qjm/GCWWLZ7IBFLFJqAm8eXLYaAEB4eIgKrE/1fuIGFm
	gbWMEnO6vUFsIQFbiW/nzzGC2JwCdhIvHjSCLRAWsJRoOHAFLM4C1Nr59AlYnBeo/tTbw8wQ
	tqDEj8n3WCBmakms33mcCcKWl9i85i0zyFoJAXWJR391QcIiAkYSd29/ZIcoEZHY9+IdI8jJ
	EgKP2CUa3m5lgdglIPFt8iEWiF5ZiU0HoAEhKXFwxQ2WCYwSs5BsnoVk8ywkm2chWbGAkWUV
	o2hqQXJBcVJ6kaFecWJucWleul5yfu4mRkjE9u5gvH3A+hBjMtD6icxSosn5wIjPK4k3NDYz
	sjA1MTU2Mrc0I01YSZw36WFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZG3/6NcgfNlTMv
	Wz9LiazXdNvvMPXFwwyfG/mCquv9sjlyl+3sLq2RT5om78Oek+lQa5PmW3iBl0MvdOt/LctG
	LaGZ69e1ZXx1mba8LGvlhfWbHmyuysyNq7QqKrgcYH3vVOD3v8q6Jv2/rzQYrahP1w2yzmNK
	Zc/hm/WyUOHSnOA3OYrzFymxFGckGmoxFxUnAgCAF84a7gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jAV2DJWeCDLpWGVpMnbydzWLqwyds
	FpcXXmK1+Halg8ni8q45bBZvfpxlcmDz2DnrLrvHplWdbB59W1Yxehy/sZ3J4/MmuQDWqAZG
	m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygE5QUyhJz
	SoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGXeaigqWc1R8+n6YpYHxEVsXIyeH
	hICJxIeTh9ghbDGJC/fWA8W5OIQEFjFKLJrXyA7h/GKUWLZ4IhNIFZuAmsSXL4eBEhwcIgKq
	Ev9fuYOEmQXWMkrM6fYGsYUEbCW+nT/HCGJzCthJvHjQyApiCwtYSjQcuAIWZwFq7Xz6BCzO
	C1R/6u1hZghbUOLH5HssEDO1JNbvPM4EYctLbF7zlhlkrYSAusSjv7ogYREBI4m7tz+yQ5SI
	SOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4H
	z6R3MK5qsDjEKMDBqMTDe0PtTJAQa2JZcWXuIUYJDmYlEd5j3UAh3pTEyqrUovz4otKc1OJD
	jMlAj05klhJNzgemqrySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi
	4JRqYFwj3sJblJcu05Phr3xy1u2X+q0b3c+uU1CcYpA07YWvUvP8vQXHPU0ELiz1r/uQF130
	cNLzlZcnW099WLZyPs+rQ9Ltc1Na6jRSvUwchAPsdY9P239ntkMs26VHRhMycleXRhlJTb+Y
	fdCqc9Zjx+dbY60+qVfueT+xzkrul+6a84wsj4t63iixFGckGmoxFxUnAgCxOde5SwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch warnings.

  WARNING: please, no space before tabs
  WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Nishanth Menon <nm@ti.com>
---
 drivers/regulator/twl-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 8ebd785..fed28ab 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -58,7 +58,7 @@ struct twlreg_info {
 	struct regulator_desc	desc;
 
 	/* chip specific features */
-	unsigned long 		features;
+	unsigned long		features;
 
 	/*
 	 * optional override functions for voltage set/get
@@ -1128,7 +1128,7 @@ static int twlreg_probe(struct platform_device *pdev)
 	if (!initdata)
 		return -EINVAL;
 
-	info = kmemdup(template, sizeof (*info), GFP_KERNEL);
+	info = kmemdup(template, sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
-- 
1.7.10.4


