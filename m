Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab3LWUvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 15:51:18 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:33484 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654Ab3LWUvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 15:51:16 -0500
From: Hayato Suzuki <hytszk@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Hayato Suzuki <hytszk@gmail.com>
Subject: [PATCH] [trivial] powernv: Fix typo in opal-flash.c
Date: Tue, 24 Dec 2013 05:51:02 +0900
Message-Id: <1387831862-4371-1-git-send-email-hytszk@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in opal-flash.c

Signed-off-by: Hayato Suzuki <hytszk@gmail.com>
---
 arch/powerpc/platforms/powernv/opal-flash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/opal-flash.c b/arch/powerpc/platforms/powernv/opal-flash.c
index 4aeae4f..d8f67ba 100644
--- a/arch/powerpc/platforms/powernv/opal-flash.c
+++ b/arch/powerpc/platforms/powernv/opal-flash.c
@@ -105,7 +105,7 @@ struct image_header_t {
 
 struct validate_flash_t {
 	int		status;		/* Return status */
-	void		*buf;		/* Candiate image buffer */
+	void		*buf;		/* Candidate image buffer */
 	uint32_t	buf_size;	/* Image size */
 	uint32_t	result;		/* Update results token */
 };
@@ -481,7 +481,7 @@ static int alloc_image_buf(char *buffer, size_t count)
 
 	memcpy(&image_header, (void *)buffer, sizeof(struct image_header_t));
 	image_data.size = be32_to_cpu(image_header.size);
-	pr_debug("FLASH: Candiate image size = %u\n", image_data.size);
+	pr_debug("FLASH: Candidate image size = %u\n", image_data.size);
 
 	if (image_data.size > MAX_IMAGE_SIZE) {
 		pr_warn("FLASH: Too large image\n");
-- 
1.8.4.2

