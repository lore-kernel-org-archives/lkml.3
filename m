Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbbANOlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:41:47 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39226 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbbANOlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:41:44 -0500
From: Arno Tiemersma <arno.tiemersma@gmail.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.com, jinshan.xiong@intel.com, gdonald@gmail.com,
        viro@zeniv.linux.org.uk, standby24x7@gmail.com
Cc: HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Arno Tiemersma <arno.tiemersma@gmail.com>
Subject: [PATCH] staging: lustre: Add blank lines after declarations
Date: Wed, 14 Jan 2015 15:41:33 +0100
Message-Id: <1421246493-15305-1-git-send-email-arno.tiemersma@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes this checkpatch warning:
WARNING: Missing a blank line after declarations

Signed-off-by: Arno Tiemersma <arno.tiemersma@gmail.com>
---
 drivers/staging/lustre/lustre/include/lclient.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/lustre/lustre/include/lclient.h b/drivers/staging/lustre/lustre/include/lclient.h
index b3b841f..316500c 100644
--- a/drivers/staging/lustre/lustre/include/lclient.h
+++ b/drivers/staging/lustre/lustre/include/lclient.h
@@ -135,6 +135,7 @@ static inline struct ccc_thread_info *ccc_env_info(const struct lu_env *env)
 static inline struct cl_attr *ccc_env_thread_attr(const struct lu_env *env)
 {
 	struct cl_attr *attr = &ccc_env_info(env)->cti_attr;
+
 	memset(attr, 0, sizeof(*attr));
 	return attr;
 }
@@ -142,6 +143,7 @@ static inline struct cl_attr *ccc_env_thread_attr(const struct lu_env *env)
 static inline struct cl_io *ccc_env_thread_io(const struct lu_env *env)
 {
 	struct cl_io *io = &ccc_env_info(env)->cti_io;
+
 	memset(io, 0, sizeof(*io));
 	return io;
 }
-- 
2.1.0

