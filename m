Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab3GVInA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:43:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24418 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab3GVIm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:42:58 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-48-51ecf09124f2
From: Jingoo Han <jg1.han@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] block: blk-sysfs: replace strict_strtoul() with kstrtoul()
Date: Mon, 22 Jul 2013 17:42:57 +0900
Message-id: <000601ce86b7$76e947e0$64bbd7a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6Gt0tCWdtkVwb4TlC7VOICAeO8Wg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zA92JH94EGqyeqWgxZ/0aNovVd/vZ
	LC4vvMRqcXnXHDYHFo/LZ0s9Tsz4zeLRt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGU92T2Av
	6GetePT4DEsDYw9LFyMHh4SAicT67sQuRk4gU0ziwr31bCC2kMAyRomLR/Mh4iYSc+fNYu1i
	5AKKT2eUWPxrBQuE84tR4taq+YwgVWwCahJfvhxmB7FFBHQlVj3fxQxiMwskSWx59QfMFhbw
	ltg/ZxcriM0ioCqxZ99+sDivgKXEhSOzWSFsQYkfk++xQPRqSazfeZwJwpaX2LzmLTPERQoS
	O86+ZoTYpSexaPsPRogaEYl9L94xQtSsY5c4fy8bYpeAxLfJh6AelpXYdABqjKTEwRU3WCYw
	is1CsnkWks2zkGyehWTDAkaWVYyiqQXJBcVJ6UWGesWJucWleel6yfm5mxghEda7g/H2AetD
	jMlA6ycyS4km5wMjNK8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc
	1OJDjEwcnFINjKvvbt216HCo4Tm5zX2VC/w++BhZq0duniK7dMKTyVKSk92NmX76S6vzSYSe
	4NvpN2fJer2uVN2bbadkwh4ZBPftOS6gu2xWfNKu/16h355NmJ7mEnVizsxb5XVnjMP/hado
	1IvNvX7nel95YJX76i55hpxc43lmE6Ij+F/vur+/Skpz67rnjkosxRmJhlrMRcWJAFu/WIzG	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jQd2JH94EGhx6KmsxZ/0aNovVd/vZ
	LC4vvMRqcXnXHDYHFo/LZ0s9Tsz4zeLRt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ+SmZeem2
	St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QCuVFMoSc0qBQgGJxcVK+naYJoSGuOla
	wDRG6PqGBMH1GBmggYR1jBlPdk9gL+hnrXj0+AxLA2MPSxcjJ4eEgInE3HmzWCFsMYkL99az
	dTFycQgJTGeUWPxrBQuE84tR4taq+YwgVWwCahJfvhxmB7FFBHQlVj3fxQxiMwskSWx59QfM
	Fhbwltg/ZxfYVBYBVYk9+/aDxXkFLCUuHJnNCmELSvyYfI8FoldLYv3O40wQtrzE5jVvmSEu
	UpDYcfY1I8QuPYlF238wQtSISOx78Y5xAqPALCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrP
	NdIrTswtLs1L10vOz93ECI7iZ9I7GFc1WBxiFOBgVOLhbQh4EyjEmlhWXJl7iFGCg1lJhNdz
	FVCINyWxsiq1KD++qDQntfgQYzLQpxOZpUST84EJJq8k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt
	1oFCAumJJanZqakFqUUwW5g4OKUaGH3iFVa9dD0ZGZjKPl995qelfzepV07cwWVRFCH2fJ/H
	7EXHzX1sAjZrs3Uoz+W42bHHZtfM9YzTd20tDc4ov7qYw8wqIZ5xj1xDHsPy9uWTE7vbC463
	ypj/2RZo3FBYbjJBmE0tVEy7i/HYqg6eEy4nNBrE+Xn1OsTaywX8Xwrtb5RrfsKvxFKckWio
	xVxUnAgAOJJ5eyYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 block/blk-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 5efc5a6..3aa5b19 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -29,7 +29,7 @@ queue_var_store(unsigned long *var, const char *page, size_t count)
 	int err;
 	unsigned long v;
 
-	err = strict_strtoul(page, 10, &v);
+	err = kstrtoul(page, 10, &v);
 	if (err || v > UINT_MAX)
 		return -EINVAL;
 
-- 
1.7.10.4


