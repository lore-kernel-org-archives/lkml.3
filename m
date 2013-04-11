Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934663Ab3DKXRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:17:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8585 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934041Ab3DKXQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:16:23 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=2E6mTtQT_NsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=kBo4se-EVHkA:10 a=zRKbQ67AAAAA:8 a=jvosBQKH23Lw0TX38SUA:9 a=1Dwx9gnmAe4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411231621.108638743@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 19:11:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 8/9 ] sfc: Correctly initialise reset_method in siena_test_chip()
References: <20130411231149.302144972@goodmis.org>
Content-Disposition: inline; filename=0008-sfc-Correctly-initialise-reset_method-in-siena_test_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit ef492f11efed9a6a1686bf914fb74468df59385c ]

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/sfc/siena.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index 4d9bd9b..7470163 100644
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
1.7.10.4


