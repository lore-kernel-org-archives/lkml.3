Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab3LKHMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:12:07 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:22942 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3LKHMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:12:00 -0500
X-AuditID: cbfee691-b7fd26d000003f7b-8d-52a8103e64d1
Message-id: <1386745856.2101.153.camel@kjgkr>
Subject: Re: [PATCH 2/2 v2] f2fs: fix the location of tracepoint
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 11 Dec 2013 16:10:56 +0900
In-reply-to: <1386741927-6007-2-git-send-email-jaegeuk.kim@samsung.com>
References: <1386741927-6007-1-git-send-email-jaegeuk.kim@samsung.com>
 <1386741927-6007-2-git-send-email-jaegeuk.kim@samsung.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zfV07gRVBBk+fKFtcWuRusWfvSRaL
	y7vmsDkwe+xe8JnJ4/MmuQCmKC6blNSczLLUIn27BK6Ma/f4CjZzV9w4sJatgXEFZxcjJ4eE
	gInEq9cTWCBsMYkL99azdTFycQgJLGOUuLr6OytM0eemfiaIxCJGiY9PbrJCOK8YJS6cns8I
	UsUroCux6EUPM4gtLOAg8ffSW6A4BwebgLbE5v0GIGEhAUWJt/vvsoKERYDsy++dQExmAQ+J
	XcdKQUwWAVWJI1uiQYo5BdwluudcZ4FobGaU2DpZFcTmFxCVOLxwO9geZgF1iUnzFjFDXKkk
	sbu9kx0iLi+xec1bZoi7BCV+TL7HAnKwhMAmdoklf5YygSRYBAQkvk0+xAKyV0JAVmLTAag5
	khIHV9xgmcAoMQvJillIxs5CMnYBI/MqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjJC4mriD
	8f4B60OMyUArJzJLiSbnA+MyryTe0NjMyMLUxNTYyNzSjDRhJXHe9EdJQUIC6YklqdmpqQWp
	RfFFpTmpxYcYmTg4pRoYW20FX8xT7tVWcTDUN28TWZSpw78qwUbCv775adIKySuT1PZKWzuJ
	ip95r3yUqUjYtPeMS/9H/698kkl6y5rfef4+It+389VfK4Wb/4yXO02tfsqduZtL5HtbS1nj
	AqnJXVsnpxmK9LSu3dBl1+yhcj8qef3GL3tFWLNS9nlr1j2+oSG1nU2JpTgj0VCLuag4EQAE
	94TowQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgK6dwIogg4l/5S0uLXK32LP3JIvF
	5V1z2ByYPXYv+Mzk8XmTXABTVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmS
	Ql5ibqqtkotPgK5bZg7QDiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1j
	xrV7fAWbuStuHFjL1sC4grOLkZNDQsBE4nNTPxOELSZx4d56ti5GLg4hgUWMEh+f3GSFcF4x
	Slw4PZ8RpIpXQFdi0YseZhBbWMBB4u+lt0BxDg42AW2JzfsNQMJCAooSb/ffZQUJiwDZl987
	gZjMAh4Su46VgpgsAqoSR7ZEgxRzCrhLdM+5zgLR2MwosXWyKojNLyAqcXjhdrA9zALqEpPm
	LWKGuFJJYnd7JztEXF5i85q3zBB3CUr8mHyPZQKj0CwkLbOQlM1CUraAkXkVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnDUPpPewbiqweIQowAHoxIP74Gi5UFCrIllxZW5hxglOJiVRHhX
	MKwIEuJNSaysSi3Kjy8qzUktPsSYDPTcRGYp0eR8YELJK4k3NDYxM7I0MrMwMjE3J01YSZz3
	YKt1oJBAemJJanZqakFqEcwWJg5OqQZGYUG+90+TtgkvTTjK7PG35sqn6Ycqf53SbFlqPjF3
	Wqnxvr2+Dj/n23FcPKysk6kcmXvSd1lysvn2r9eZkh4dZMj6ynGvrX1OS3jo1ywdYxH3f2YZ
	0v9ZTkaeTdfR4T4uPm9x23f54qMiFQy7BNTZl5pc+/bHV7bB5+eJX25Hf1/aaJmT2JWoxFKc
	kWioxVxUnAgAzUGbWx4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log from v1:
 o fix a mistake

>From 59df095b83e601b1b317ce97a5f767a8c3303902 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Wed, 11 Dec 2013 14:29:39 +0900
Subject: [PATCH] f2fs: fix the location of tracepoint
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

We need to get a trace before submit_bio, since its bi_sector is
remapped during
the submit_bio.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index ebc9177..15956fa 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -104,11 +104,12 @@ static void __submit_merged_bio(struct
f2fs_bio_info *io)
 	rw = fio->rw | fio->rw_flag;
 
 	if (is_read_io(rw)) {
-		submit_bio(rw, io->bio);
 		trace_f2fs_submit_read_bio(io->sbi->sb, rw, fio->type, io->bio);
+		submit_bio(rw, io->bio);
 		io->bio = NULL;
 		return;
 	}
+	trace_f2fs_submit_write_bio(io->sbi->sb, rw, fio->type, io->bio);
 
 	/*
 	 * META_FLUSH is only from the checkpoint procedure, and we should
wait
@@ -122,7 +123,6 @@ static void __submit_merged_bio(struct f2fs_bio_info
*io)
 	} else {
 		submit_bio(rw, io->bio);
 	}
-	trace_f2fs_submit_write_bio(io->sbi->sb, rw, fio->type, io->bio);
 	io->bio = NULL;
 }
 
-- 
1.8.4.474.g128a96c


-- 
Jaegeuk Kim
Samsung

