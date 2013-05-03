Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762417Ab3ECBvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 21:51:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28083 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3ECBu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 21:50:59 -0400
X-AuditID: cbfee690-b7f136d000000fea-ec-5183180052dc
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: "'Rusty Russell'" <rusty@rustcorp.com.au>,
        "'Michael S. Tsirkin'" <mst@redhat.com>
References: 
In-reply-to: 
Subject: [PATCH] virtio_blk: Add missing 'static' qualifiers
Date: Fri, 03 May 2013 10:50:55 +0900
Message-id: <001101ce47a0$a6bfa500$f43eef00$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zI10GieZAg++7WS2WNHNbXN41h83i
	/69XrBY3p11gcWDxeL/vKpvHig0nmD36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr4/DWPSwF
	V1kqDn/KaWD8xtzFyMkhIWAicfbDcXYIW0ziwr31bF2MXBxCAssYJc6vOMEKU7Sz9ycLRGIR
	o8SH9f+hqv4ySvzc9JYRpIpNQFfi2PotYB0iAt4Sp6b8AlvBLBAmseNqM1A3B1ADt8Tq5iCQ
	MKcAj8S6P51gJcICNhIPVhxiA7FZBFQl+m9/AhvJK2An8XVXJxOELSjxY/I9FoiRWhKbtzWx
	QtjyEpvXvGUGGS8hoC7x6K8uxAV+Ehc+H4EqEZHY9+IdI8jJEgLH2CX+3P7CCrFLQOLb5EMs
	EL2yEpsOQANFUuLgihssExglZiHZPAvJ5llINs9CsmIBI8sqRtHUguSC4qT0IhO94sTc4tK8
	dL3k/NxNjJCInLCD8d4B60OMyUDrJzJLiSbnAyM6ryTe0NjMyMLUxNTYyNzSjDRhJXFe9Rbr
	QCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M3ufeCbG0FtyLubPeL2euVFJbCtOXxtpjsVPn
	eR9str6W7HBk2fnJ/+L5ufzmVE3Qupj+9afJyylrHyUeXlUgnn61RcbiXtHuL+c27Yg4aGV1
	T1dry6JTEyUaPp5vXb7prsEs3wLhKXkq7z5oywd9tN4g9kxlq3Pih4kZDppJTNFvzavPZr+U
	V2Ipzkg01GIuKk4EALtnGMPeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAV0GieZAg5cPGS2WNHNbXN41h83i
	/69XrBY3p11gcWDxeL/vKpvHig0nmD36tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMePw1j0sBVdZKg5/ymlg/MbcxcjJISFgIrGz9ycLhC0mceHeerYu
	Ri4OIYFFjBIf1v+Hcv4ySvzc9JYRpIpNQFfi2PotrCC2iIC3xKkpv8AmMQuESey42gw0iQOo
	gVtidXMQSJhTgEdi3Z9OsBJhARuJBysOsYHYLAKqEv23P4GN5BWwk/i6q5MJwhaU+DH5HgvE
	SC2JzduaWCFseYnNa94yg4yXEFCXePRXF+ICP4kLn49AlYhI7HvxjnECo9AsJJNmIZk0C8mk
	WUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjvdnUjsYVzZYHGIU4GBU4uFVaGkK
	FGJNLCuuzD3EKMHBrCTC6/YDKMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wFSUVxJvaGxi
	ZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MzVk7SmMWs+q6KP4t1Jnw
	zZLR4HR1756/chf7Tm3b1pOXWdDzUJTJkdG/N2s5c12MfVFsV//X7dqWNr7VYV/CWU4p8u+b
	5aDJPmW53o1NJktW1rpf4FrnyrR84tOM0+18HyVPhTwxV3VMuKiacV9ift0CFbMFrywcr97e
	GRb1umLrffszx7WVWIozEg21mIuKEwE2JlhDOwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing 'static' qualifiers

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/block/virtio_blk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 6472395..5cdf88b 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -20,7 +20,7 @@ module_param(use_bio, bool, S_IRUGO);
 static int major;
 static DEFINE_IDA(vd_index_ida);
 
-struct workqueue_struct *virtblk_wq;
+static struct workqueue_struct *virtblk_wq;
 
 struct virtio_blk
 {
-- 
1.7.9.5

