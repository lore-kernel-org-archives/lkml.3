Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965418Ab3CZPYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:24:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54136 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965389Ab3CZPX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 131/150] sfc: Correctly initialise reset_method in siena_test_chip()
Date: Tue, 26 Mar 2013 15:20:30 +0000
Message-Id: <1364311249-14454-132-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit ef492f11efed9a6a1686bf914fb74468df59385c upstream.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/siena.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index 2011319..b09ff79 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -170,7 +170,7 @@ static const struct efx_nic_register_test siena_register_tests[] = {
 
 static int siena_test_chip(struct efx_nic *efx, struct efx_self_tests *tests)
 {
-	enum reset_type reset_method = reset_method;
+	enum reset_type reset_method = RESET_TYPE_ALL;
 	int rc, rc2;
 
 	efx_reset_down(efx, reset_method);
-- 
1.8.1.2

