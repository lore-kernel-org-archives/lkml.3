Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab3LKGGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 01:06:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:64674 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3LKGGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 01:06:36 -0500
X-AuditID: cbfee691-b7fd26d000003f7b-ff-52a800eadd1a
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: fix the location of tracepoint
Date: Wed, 11 Dec 2013 15:05:27 +0900
Message-id: <1386741927-6007-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1386741927-6007-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1386741927-6007-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zQ91XDCuCDPZ8FrG4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+P1i+9MBXvYK75+
	e8HYwNjN1sXIySEhYCJx+e4+RghbTOLCvfVAcS4OIYFljBJP975ihSmavugdWIOQwCJGiVsn
	hSGKmpkkps1dztLFyMHBJqAtsXm/AUiNiACzxIKp5xlBapgFJjBK/F/0ngUkISxgKXHoxBKw
	QSwCqhLtbxeALeAVcJPo3DkLapm2xLbnE8Eu4hRwlzh46CMTxGI3iXf3+sCGSgh8Z5NYNP0x
	K8QgAYlvkw+BHSEhICux6QAzxBxJiYMrbrBMYBRewMiwilE0tSC5oDgpvchUrzgxt7g0L10v
	OT93EyMkZCfuYLx/wPoQYzLQuInMUqLJ+cCQzyuJNzQ2M7IwNTE1NjK3NCNNWEmcN/1RUpCQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGxi1H26/M6Uqe9O/rCae1z37vMXc2Xlm/0mvJZo6l
	80JmPdnD2H29LXtKsvoamXZ1ibf3b0jVNXvm+q3ae3pRpPrJuwfEzq7OWvrszCXrRPGM4DLp
	VDc9+TsFS0yfH1qQOs9XR9kj6WHE+SObj3Uc9Vmhfmlz8dOjYYJuZioxboYXGO9vjCiUjVdi
	Kc5INNRiLipOBACj/sBBbwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAd1XDCuCDOZcELS4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHj9YvvTAV72Cu+fnvB2MDYzdbFyMkhIWAiMX3ROyhbTOLCvfVgtpDAIkaJ
	WyeFuxi5gOxmJolpc5ezdDFycLAJaEts3m8AUiMiwCyxYOp5RpAaZoEJjBL/F71nAUkIC1hK
	HDqxBGwQi4CqRPvbBawgNq+Am0TnzlmsEMu0JbY9n8gIYnMKuEscPPSRCWKxm8S7e32MExh5
	FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjohnUjsYVzZYHGIU4GBU4uE9ULQ8SIg1
	say4MvcQowQHs5II70ZToBBvSmJlVWpRfnxRaU5q8SHGZKCrJjJLiSbnA6M1ryTe0NjEzMjS
	yMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYlde93rRTtOnCVi817eUJd2Yz
	ruKY8T5ITUjETe/esb3eFzbOqdprwXtpz4o9fu/jkgxnsPF/zOD+23JRgTlh13KjS7fY9lme
	Xnbgzry4Q5cf+TOlqe+SXNR3UEnHZc+8yN6zbLe552ZNX1HMveebU+I/GxOW2Hv+Ly+caZ7x
	8EtqFJPPVvvnh5VYijMSDbWYi4oTASYngCjMAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to get a trace before submit_bio, since its bi_sector is remapped during
the submit_bio.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index ebc9177..969df55 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -103,9 +103,10 @@ static void __submit_merged_bio(struct f2fs_bio_info *io)
 
 	rw = fio->rw | fio->rw_flag;
 
+	trace_f2fs_submit_write_bio(io->sbi->sb, rw, fio->type, io->bio);
+
 	if (is_read_io(rw)) {
 		submit_bio(rw, io->bio);
-		trace_f2fs_submit_read_bio(io->sbi->sb, rw, fio->type, io->bio);
 		io->bio = NULL;
 		return;
 	}
@@ -122,7 +123,6 @@ static void __submit_merged_bio(struct f2fs_bio_info *io)
 	} else {
 		submit_bio(rw, io->bio);
 	}
-	trace_f2fs_submit_write_bio(io->sbi->sb, rw, fio->type, io->bio);
 	io->bio = NULL;
 }
 
-- 
1.8.4.474.g128a96c

