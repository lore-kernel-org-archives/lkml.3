Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab3CZXSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:18:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab3CZWwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 25/72] sfc: Correctly initialise reset_method in siena_test_chip()
Date: Tue, 26 Mar 2013 15:51:08 -0700
Message-Id: <20130326224922.308357333@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit ef492f11efed9a6a1686bf914fb74468df59385c ]

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/siena.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -170,7 +170,7 @@ static const struct efx_nic_register_tes
 
 static int siena_test_chip(struct efx_nic *efx, struct efx_self_tests *tests)
 {
-	enum reset_type reset_method = reset_method;
+	enum reset_type reset_method = RESET_TYPE_ALL;
 	int rc, rc2;
 
 	efx_reset_down(efx, reset_method);


