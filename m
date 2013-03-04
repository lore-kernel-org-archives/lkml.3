Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab3CDI45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:56:57 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:64825 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab3CDI44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:56:56 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-52-513461d6b4ba
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: ep93xx_bl: remove incorrect __exit annotation
Date: Mon, 04 Mar 2013 17:56:54 +0900
Message-id: <015501ce18b6$3819c310$a84d4930$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YtjgDnfWDblDbSP+ou/QMT1c6bg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t8zI91riSaBBvMnaltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mb/cmsxWcZqt49XELSwPjWdYuRg4OCQETiccHE7oYOYFMMYkL
	99azdTFycQgJLGOU+HXtKTtEwkTiUstaZojEIkaJI9t/s0I4s5kkJq5sZQGpYhNQk/jy5TA7
	yFQRAX2JthYNkDCzQKnE1gfvwUqEBTwlrr1fygpiswioSkz//4EJxOYVsJW4+2kHM4QtKPFj
	8j0WiF4tifU7jzNB2PISm9e8ZYY4Wl3i0V9dkLCIgJ7E+9d32CFKRCT2vXjHCHKahEA/u8TJ
	/w8ZIXYJSHybfIgFoldWYtMBZoi/JCUOrrjBMoFRbBaSzbOQbJ6FZPMsJCsWMLKsYhRNLUgu
	KE5KLzLVK07MLS7NS9dLzs/dxAiJk4k7GO8fsD7EmAy0fiKzlGhyPjDO8kriDY2NTcxMTE3M
	LU3NTUkTVhLnlb8kEygkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMY3fjOXkRXmtdaWJaoXZ
	PSUtC7T2FOd0BJ0PEDzjnvz2i9JhgcOO096q/WvIOdp4S4v3RhjLKaF37emqq07e0lrvW29R
	JaX8YXd/+1ZZMd1Ah8tiFf9aqySSl1c29NusvHa1etkZS+OV63cJP6nv1Re/4va0bI52x89n
	NrdW5pW9/fAswEFGiaU4I9FQi7moOBEAHkFa4KkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAd1riSaBButmqllc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjG/3JrMVnGarePVxC0sD
	41nWLkZODgkBE4lLLWuZIWwxiQv31rN1MXJxCAksYpQ4sv03K4Qzm0li4spWFpAqNgE1iS9f
	DrN3MXJwiAjoS7S1aICEmQVKJbY+eA9WIizgKXHt/VKwBSwCqhLT/39gArF5BWwl7n7awQxh
	C0r8mHyPBaJXS2L9zuNMELa8xOY1b5lBxksIqEs8+qsLEhYR0JN4//oOO0SJiMS+F+8YJzAK
	zEIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOA4fCa9g3FVg8Uh
	RgEORiUeXoFPxoFCrIllxZW5hxglOJiVRHgjEkwChXhTEiurUovy44tKc1KLDzEmAz06kVlK
	NDkfmCLySuINjU3MjCyNzCyMTMzNSRNWEudlPPUkQEggPbEkNTs1tSC1CGYLEwenVAPjJMcb
	Zwp/nDnDZy0ofPRHSDjL4b2rrjHPvT9z7p+PkizTC964lEecejWbi6FR6M0i/4lnJcLN9r/Y
	5ON//e3nV/8O63qoVxqs+MwQrPAu7sTJ7RFtds9Sw3zUTn7bcmed9s1Pnoo/jhgZT2/awirw
	7uT58oJdGx3cyxYF2i4q3Dn75s6oCXs3WCmxFGckGmoxFxUnAgAMxS0pBwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When platform_driver_probe() is not used, bind/unbind via sysfs is
enabled. Thus, __init/__exit annotations should be removed from
probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ep93xx_bl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
index ef3e21e..fd073b2 100644
--- a/drivers/video/backlight/ep93xx_bl.c
+++ b/drivers/video/backlight/ep93xx_bl.c
@@ -60,7 +60,7 @@ static const struct backlight_ops ep93xxbl_ops = {
 	.get_brightness	= ep93xxbl_get_brightness,
 };
 
-static int __init ep93xxbl_probe(struct platform_device *dev)
+static int ep93xxbl_probe(struct platform_device *dev)
 {
 	struct ep93xxbl *ep93xxbl;
 	struct backlight_device *bl;
-- 
1.7.2.5


