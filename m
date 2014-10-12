Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaJLUmj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:42:39 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50071 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbaJLUlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:41:09 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 13/15] media: davinci: vpbe: drop unused member memory from vpbe_layer
Date: Sun, 12 Oct 2014 21:40:43 +0100
Message-Id: <1413146445-7304-14-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 include/media/davinci/vpbe_display.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/media/davinci/vpbe_display.h b/include/media/davinci/vpbe_display.h
index de0843d..163a02b 100644
--- a/include/media/davinci/vpbe_display.h
+++ b/include/media/davinci/vpbe_display.h
@@ -91,10 +91,6 @@ struct vpbe_layer {
 	/* V4l2 specific parameters */
 	/* Identifies video device for this layer */
 	struct video_device video_dev;
-	/* This field keeps track of type of buffer exchange mechanism user
-	 * has selected
-	 */
-	enum v4l2_memory memory;
 	/* Used to store pixel format */
 	struct v4l2_pix_format pix_fmt;
 	enum v4l2_field buf_field;
-- 
1.9.1

