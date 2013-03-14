Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab3CNIJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:09:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41356 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3CNIJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:09:26 -0400
X-AuditID: cbfee68d-b7f786d000005188-00-514185b44b49
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008201ce208b$27435470$75c9fd50$%han@samsung.com>
In-reply-to: <008201ce208b$27435470$75c9fd50$%han@samsung.com>
Subject: [PATCH 2/2] rtc: rtc-fm3130: use dev_dbg() instead of pr_debug()
Date: Thu, 14 Mar 2013 17:09:24 +0900
Message-id: <008301ce208b$3d996890$b8cc39b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4giyaoazxrxLGpTaGs2jjBBAJCGwAAAVEg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zI90trY6BBstXGVksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVceThRsaCZtaKRUdbWBoYu1i6GDk4JARMJG7cFO5i5AQyxSQu3FvP1sXIxSEksIxR
	4sTjH0wQCROJ8xd3s4DYQgLTGSXadidC2L8YJa5N0Aex2QTUJL58OcwOMlNEQF+irUUDZA6z
	QC+jxJne3ewQ9bYSJ4+8ZwOxOQXsJH7vPcwKUi8s4CmxdQcrSJhFQFViSt9jsBJeoPJfC0+z
	QtiCEj8m3wM7gVlAS2L9zuNMELa8xOY1b5khXlGXePRXFyQsImAkcXLbdnaIEhGJfS/eMYKc
	IyFwi13i/JSNTBC7BCS+TT4EDQZZiU0HmCG+lZQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiy
	ilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMkRnt3MN4+YH2IMRlo/URmKdHkfGCM55XEGxqb
	GVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBsdnq3z7r8znP
	e9alOWxaMTuW0fhqZZv5D+n9R47ssF9i7mQms6K6/b+L+Zb5P+4aBb9xzPRZPmOCVN6lP+f7
	Dlp6LTp8dBK/ftiJbqdukReH9v5fW8XQyHphyvGDS92cniu6e099tIalf/XmN9f/v9OInKl4
	82lF16pNWbdqOyVLDWp7I/9M36bEUpyRaKjFXFScCABz1Ryr5wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd0trY6BBjtn6FksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHHk4UbGgmbWikVHW1gaGLtYuhg5OSQETCTO
	X9wNZYtJXLi3ng3EFhKYzijRtjsRwv7FKHFtgj6IzSagJvHly2H2LkYODhEBfYm2Fo0uRi4O
	ZoFeRokzvbvZIeptJU4eeQ82h1PATuL33sOsIPXCAp4SW3ewgoRZBFQlpvQ9BivhBSr/tfA0
	K4QtKPFj8j2wc5gFtCTW7zzOBGHLS2xe85YZZIyEgLrEo7+6IGERASOJk9u2s0OUiEjse/GO
	cQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOAc+kdzCu
	arA4xCjAwajEwxsh6hgoxJpYVlyZe4hRgoNZSYTX0wsoxJuSWFmVWpQfX1Sak1p8iDEZ6NGJ
	zFKiyfnA9JRXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzb
	2gXE/x7dGcmnG+OctWO697SaqMWJKaqi8xb1sGrZuK2Z7rLuTWXf6Tdvl14qZdLdlVzl/SFl
	SZtk+eJ3Jx3adMLu/Yj8/rd3f+fs0o+zbS0vVvmt39G5/PnGZywv7W7JbJxUWHs9xEu10tK7
	fuI+jguxm/bP+6QfInLCdeJca5vg9uQ3bsFKLMUZiYZazEXFiQAjmKfSRQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_dbg() is more preferred than pr_debug().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-fm3130.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-fm3130.c b/drivers/rtc/rtc-fm3130.c
index bff3cdc..4d4ad3f 100644
--- a/drivers/rtc/rtc-fm3130.c
+++ b/drivers/rtc/rtc-fm3130.c
@@ -395,7 +395,7 @@ static int fm3130_probe(struct i2c_client *client,
 
 	tmp = i2c_transfer(adapter, fm3130->msg, 4);
 	if (tmp != 4) {
-		pr_debug("read error %d\n", tmp);
+		dev_dbg(&client->dev, "read error %d\n", tmp);
 		err = -EIO;
 		goto exit_free;
 	}
-- 
1.7.2.5


