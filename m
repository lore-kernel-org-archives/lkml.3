Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaG2IEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:04:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60256 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaG2IEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:04:32 -0400
X-AuditID: cbfee691-b7f306d000003d81-d4-53d7558b39d7
From: Sangjung Woo <sangjung.woo@samsung.com>
To: Wim Van Sebroeck <wim@iguana.be>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sangjung Woo <sangjung.woo@samsung.com>, again4you@gmail.com
Subject: [PATCH] Documentation: fix a typo in watchdog-api.txt
Date: Tue, 29 Jul 2014 17:04:24 +0900
Message-id: <1406621064-5466-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWyRsSkULcn9HqwwYJwi5P9/SwWl3fNYbO4
	sW4fu8XbO9NZLBbsKbG4NeMFqwObx85Zd9k9rm0W89i8Qsujb8sqRo/Pm+QCWKO4bFJSczLL
	Uov07RK4Mpb9ecpa8Jet4vcH1gbGh6xdjJwcEgImEsfmXIKyxSQu3FvP1sXIxSEksJRR4t6M
	fwhFD2axQCQWMUqsWXecCSQhJNDGJNG/KxTEZhPQlXhy4DJzFyMHh4iAl8T+qwkg9cwCDYwS
	Sx/8B6sXFrCTWP/hIQuIzSKgKvFw3gxGEJtXwF3i4tndYL0SAgoScybZgPRKCHxnk+jY+pMR
	ol5A4tvkQywQNbISmw4wQ9wmKXFwxQ2WCYyCCxgZVjGKphYkFxQnpReZ6hUn5haX5qXrJefn
	bmIEBujpf88m7mC8f8D6EGMy0LiJzFKiyfnAAM8riTc0NjOyMDUxNTYytzQjTVhJnDf9UVKQ
	kEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkYREWEtDdOcms+ih2MkWZI5pSUTfyR85d/hGBI0
	80fdrIOR2QIOCu9yVyr9VC42Dpv3NEzz49abH+eLX3K7mulk0c4zc12C7M8d343X6SzfX3/1
	fqS90GdTvhd60iyPZ7CstH50If/y0rxZ/16I3jG5I8ZybXZGtd6mEw9ezbm/7xKf+fxHewOV
	WIozEg21mIuKEwFnWzHaZgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e+xgG536PVgg1dvzS1O9vezWFzeNYfN
	4sa6fewWb+9MZ7FYsKfE4taMF6wObB47Z91l97i2Wcxj8wotj74tqxg9Pm+SC2CNamC0yUhN
	TEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHar6RQlphTChQK
	SCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMWPbnKWvBX7aK3x9YGxgfsnYxcnJICJhI
	HHswiwXCFpO4cG89WxcjF4eQwCJGiTXrjjOBJIQE2pgk+neFgthsAroSTw5cZu5i5OAQEfCS
	2H81AaSeWaCBUWLpg/9g9cICdhLrPzwEG8oioCrxcN4MRhCbV8Bd4uLZ3WC9EgIKEnMm2Uxg
	5F7AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgCnknvYFzVYHGIUYCDUYmHd8Pca8FC
	rIllxZW5hxglOJiVRHgFAq8HC/GmJFZWpRblxxeV5qQWH2I0BVo+kVlKNDkfGJ15JfGGxiZm
	RpZG5oYWRsbmSuK8B1utA4UE0hNLUrNTUwtSi2D6mDg4pRoYF90S3lBVwnB7j/tncdMPl3Ma
	dzFl73l3M85wpo3UldYnGooLqqX5m77zppSzToj/z+l759vKH0G1P9LLDu7tbnmwTf1eXd/+
	/21s3QEht44Izv4evqm+K/zNhds2W2Qufwk/cXq/rOzjbctDF794WLpgwea4L27fMqR8MwvX
	+y1c8+vVmsnyC5RYijMSDbWYi4oTAYKK/BOWAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
---
 Documentation/watchdog/watchdog-api.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/watchdog/watchdog-api.txt b/Documentation/watchdog/watchdog-api.txt
index eb7132e..53c49a4 100644
--- a/Documentation/watchdog/watchdog-api.txt
+++ b/Documentation/watchdog/watchdog-api.txt
@@ -118,7 +118,7 @@ resets.
 Note that the pretimeout is the number of seconds before the time
 when the timeout will go off.  It is not the number of seconds until
 the pretimeout.  So, for instance, if you set the timeout to 60 seconds
-and the pretimeout to 10 seconds, the pretimout will go of in 50
+and the pretimeout to 10 seconds, the pretimout will go off in 50
 seconds.  Setting a pretimeout to zero disables it.
 
 There is also a get function for getting the pretimeout:
-- 
1.7.9.5

