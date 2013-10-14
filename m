Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab3JNIrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:47:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36260 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab3JNIrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:47:41 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-0f-525bafa4eb22
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>
References: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
In-reply-to: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
Subject: [PATCH 04/11] regulator: lp3971: Fix checkpatch issue
Date: Mon, 14 Oct 2013 17:47:31 +0900
Message-id: <000301cec8ba$0530ce80$0f926b80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7IuZK01KcLw1AZSDCREfGxHfkpOgAAFKzg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zQ90l66ODDE6t5rCY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvF2iN32R1YPXbOusvusWlVJ5tH35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVw
	ZRzddIy9YB1rRc/uC2wNjAtZuhg5OSQETCQO3u9jgrDFJC7cW8/WxcjFISSwjFFi3dOJzDBF
	i9+fYIZITGeUePf2HzuE84tR4lxDA1g7m4CaxJcvh4ESHBwiAqoS/1+5g9QwC8xjlPjw7zw7
	SI2QgK3E3dOXwKZyCthJLPy2C+wMYSD7x71GNhCbBaj3fFcbK4jNC1Tfu/E1E4QtKPFj8j2w
	emYBLYn1O48zQdjyEpvXvGUG2SshoC7x6K8uSFhEwEhiyrN5UCUiEvtevGMEuUdC4Bq7xPEj
	U1kgdglIfJt8iAWiV1Zi0wGohyUlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihO
	Si8y1CtOzC0uzUvXS87P3cQIidDeHYy3D1gfYkwGWj+RWUo0OR8Y4Xkl8YbGZkYWpiamxkbm
	lmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYMycuPLVKTVh4z8xP0p3z9j6
	a8ZrFrdAjjMxnsd2bjHrO8o5k9H22hobxQgrvudrYnYuS06zvNapIXGCx/rx1yPBX1KzO7L3
	fmBI1Y8xF7TeWBb0wnbN4o2zF39/onRI9pv70UdVPQENcqZuNx//yZyVW7D1D5NQL39vi3wf
	w+3fpcdPHw2NkVZiKc5INNRiLipOBACLM4Ic5gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jQd0l66ODDNofsVhMffiEzeLywkus
	Ft+udDBZXN41h81i7ZG77A6sHjtn3WX32LSqk82jb8sqRo/Pm+QCWKIaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYrKZQl5pQChQISi4uV9O0w
	TQgNcdO1gGmM0PUNCYLrMTJAAwnrGDOObjrGXrCOtaJn9wW2BsaFLF2MnBwSAiYSi9+fYIaw
	xSQu3FvP1sXIxSEkMJ1R4t3bf+wQzi9GiXMNDUwgVWwCahJfvhwGSnBwiAioSvx/5Q5Swyww
	j1Hiw7/z7CA1QgK2EndPXwKbyilgJ7Hw2y6wbcJA9o97jWwgNgtQ7/muNlYQmxeovnfjayYI
	W1Dix+R7YPXMAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCwiICRxJRn86BKRCT2vXjHOIFR
	aBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTH/zOpHYwrGywO
	MQpwMCrx8Ao4RQcJsSaWFVfmHmKU4GBWEuEVnAcU4k1JrKxKLcqPLyrNSS0+xJgM9OhEZinR
	5HxgasoriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk4pYJSmSFRe
	uN3KbLjx2PZrW79w3Zvz3ORlwflNU2c3JD9yd8n992B9uu9DV68KgeWHtNJnePwpnGRpxLRx
	gyaLzhuV/fb6EpM+Cgo01b7wUzi2OGu7I+dGGU+Jd4yffqk23e5O38jWeF9u8p2oXauLHz7P
	KDj3wr7hTeDn+bU7Nkw5kfCHecPuD8eVWIozEg21mIuKEwG6290MQwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch warnings.

  WARNING: please, no spaces at the start of a line

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/lp3971.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 5a4604e..947c05f 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -474,8 +474,8 @@ static int lp3971_i2c_remove(struct i2c_client *i2c)
 }
 
 static const struct i2c_device_id lp3971_i2c_id[] = {
-       { "lp3971", 0 },
-       { }
+	{ "lp3971", 0 },
+	{ }
 };
 MODULE_DEVICE_TABLE(i2c, lp3971_i2c_id);
 
-- 
1.7.10.4


