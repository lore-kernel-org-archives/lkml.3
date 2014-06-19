Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240AbaFSPf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:35:59 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37248 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669AbaFSPf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:35:57 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH 1/1] staging: lustre: ldlm: ldlm_resource.c removed unecessary braces
Date: Fri, 20 Jun 2014 01:35:48 +1000
Message-Id: <1403192148-18189-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- this fixed the "WARNING: braces {} are not necessary for
  single statement blocks"

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
index c55d72f..e5171da 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
@@ -854,9 +854,8 @@ void ldlm_namespace_free_prior(struct ldlm_namespace *ns,
 {
 	int rc;
 
-	if (!ns) {
+	if (!ns)
 		return;
-	}
 
 	spin_lock(&ns->ns_lock);
 	ns->ns_stopping = 1;
@@ -888,9 +887,8 @@ void ldlm_namespace_free_prior(struct ldlm_namespace *ns,
  */
 void ldlm_namespace_free_post(struct ldlm_namespace *ns)
 {
-	if (!ns) {
+	if (!ns)
 		return;
-	}
 
 	/* Make sure that nobody can find this ns in its list. */
 	ldlm_namespace_unregister(ns, ns->ns_client);
-- 
1.9.0

