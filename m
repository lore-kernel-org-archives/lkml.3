Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab3EHXGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 19:06:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59963 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3EHXGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 19:06:17 -0400
X-AuditID: cbfee68f-b7f066d000003683-de-518ada689c91
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Philipp Reisner'" <philipp.reisner@linbit.com>,
        "'Lars Ellenberg'" <lars.ellenberg@linbit.com>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable] drbd: Fix build error when CONFIG_CRYPTO_HMAC is
 not set
Date: Thu, 09 May 2013 08:06:15 +0900
Message-id: <003701ce4c40$a44a3e30$ecdeba90$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58Q
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zQ92MW12BBm8msVksaea2mN/9nsXi
	8q45bBYvZz5msliw8RGjA6vH0ytHmDz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoErY9XLDawF
	rVwVk396NzBe4+hi5OSQEDCRuPSggRnCFpO4cG89WxcjF4eQwDJGiQlNh1lgipZPmsgMkZjO
	KNH8exIrhPOXUeLvng9sIFVsAroSx9ZvYQWxRQS8JU5N+QU2llmgSmLi1zuMXYwcQA3cEqub
	g0DCnAI8Euv+dIKVCAuESRzdtxhsGYuAqsSyO/8YQWxeATuJxa1rWCBsQYkfk++xQIzUkti8
	rYkVwpaX2LzmLTPIeAkBdYlHf3UhwiIS+168Y4S4Jkbiwed/bBC/nGKXuP/UHWKVgMS3yYdY
	IFplJTYdgIaDpMTBFTdYJjBKzEKyeBaSxbOQLJ6FZNsCRpZVjKKpBckFxUnpRcZ6xYm5xaV5
	6XrJ+bmbGCHx2L+D8e4B60OMyUDrJzJLiSbnA+M5ryTe0NjMyMLUxNTYyNzSjDRhJXFetRbr
	QCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Mi3Y+4pfSW7htVumtHB6HGzuE9t+MiZ0U6cMS
	GL+nsjl7VmRrf+nL668uCM2QnJA71WtZ1Nfe82oSx1aZpp31SP+y9MCd5RUHpKPYpJ2Sr6ae
	2vW1v3VDY5GJ4Z6cvTNnOAW5u8/X3917INlAXPPZE9+3gQEZ/vF5njz1OuoOutMjdJQj7OuU
	WIozEg21mIuKEwG144Dc3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd2MW12BBh8XMVksaea2mN/9nsXi
	8q45bBYvZz5msliw8RGjA6vH0ytHmDz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMWPVyw2sBa1cFZN/ejcwXuPoYuTkkBAwkVg+aSIzhC0mceHeerYu
	Ri4OIYHpjBLNvyexQjh/GSX+7vnABlLFJqArcWz9FlYQW0TAW+LUlF9g3cwCVRITv95h7GLk
	AGrglljdHAQS5hTgkVj3pxOsRFggTOLovsUsIDaLgKrEsjv/GEFsXgE7icWta1ggbEGJH5Pv
	sUCM1JLYvK2JFcKWl9i85i0zyHgJAXWJR391IcIiEvtevGOEuCZG4sHnf2wTGIVmIZk0C8mk
	WUgmzULSvoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcLw/k97BuKrB4hCjAAejEg9v
	RmJXoBBrYllxZe4hRgkOZiUR3rutQCHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OB6aivJJ4
	Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgDOU50GzBpb7+5Eae
	pv1nuF7sUCu9/+d/usruydlLTk5dJrZRKGV+oHS+Uemrgj0JHw7Vpt5QY1FP7n50RDT/eoZL
	dbDVdQblR9VlU2qW9pzw4lnIumpb8x7Dc04aM5Yayk/nnWBSzJQ3oXfj0zltfP6vsvfFKD9j
	S4ri1qz6oOaVeDWOWd1eiaU4I9FQi7moOBEABV7GSTsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Philipp Reisner <philipp.reisner@linbit.com>"

commit ef57f9e6bb9278720c8a5278728f252ab85d7ac6 upstream

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/block/drbd/drbd_receiver.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c
b/drivers/block/drbd/drbd_receiver.c
index 5105f43..2f5fffd 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4658,8 +4658,8 @@ static int drbd_do_features(struct drbd_tconn *tconn)
 #if !defined(CONFIG_CRYPTO_HMAC) && !defined(CONFIG_CRYPTO_HMAC_MODULE)
 static int drbd_do_auth(struct drbd_tconn *tconn)
 {
-	dev_err(DEV, "This kernel was build without CONFIG_CRYPTO_HMAC.\n");
-	dev_err(DEV, "You need to disable 'cram-hmac-alg' in drbd.conf.\n");
+	conn_err(tconn, "This kernel was build without
CONFIG_CRYPTO_HMAC.\n");
+	conn_err(tconn, "You need to disable 'cram-hmac-alg' in
drbd.conf.\n");
 	return -1;
 }
 #else
--

