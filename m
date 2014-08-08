Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719AbaHHUqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:46:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40384 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaHHUqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:46:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 156/259] [media] media: v4l2-core: v4l2-dv-timings.c: Cleaning up code wrong value used in aspect ratio
Date: Fri,  8 Aug 2014 13:39:39 -0700
Message-Id: <1407530482-4483-157-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

commit f71920efb1066d71d74811e1dbed658173adf9bf upstream.

Wrong value used in same cases for the aspect ratio.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index ee52b9f4..4a904ad 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -590,10 +590,10 @@ struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait)
 		aspect.denominator = 9;
 	} else if (ratio == 34) {
 		aspect.numerator = 4;
-		aspect.numerator = 3;
+		aspect.denominator = 3;
 	} else if (ratio == 68) {
 		aspect.numerator = 15;
-		aspect.numerator = 9;
+		aspect.denominator = 9;
 	} else {
 		aspect.numerator = hor_landscape + 99;
 		aspect.denominator = 100;
-- 
1.9.1

