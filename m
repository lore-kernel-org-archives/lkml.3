Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbaLHSgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:36:38 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:64756 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaLHSgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:36:37 -0500
From: Dean Michael Ancajas <dbancajas@gmail.com>
To: oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        HPDD-discuss@ml01.01.org, Dean Ancajas <dbancajas@gmail.com>
Subject: [PATCH] Staging: lustre: obd: Fix a coding style issue
Date: Mon,  8 Dec 2014 11:36:33 -0700
Message-Id: <1418063793-28813-1-git-send-email-dbancajas@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dean Ancajas <dbancajas@gmail.com>

Fixed a brace coding style issue for functions.

Signed-off-by: Dean Michael Ancajas <dbancajas@gmail.com>
---
 drivers/staging/lustre/lustre/obdclass/cl_object.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/cl_object.c b/drivers/staging/lustre/lustre/obdclass/cl_object.c
index ce96bd2..c40bb6c 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_object.c
@@ -662,7 +662,8 @@ static int cl_env_store_init(void) {
 	return cl_env_hash != NULL ? 0 :-ENOMEM;
 }
 
-static void cl_env_store_fini(void) {
+static void cl_env_store_fini(void)
+{
 	cfs_hash_putref(cl_env_hash);
 }
 
-- 
1.9.1

