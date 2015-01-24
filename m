Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbbAXU3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 15:29:25 -0500
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:48940 "EHLO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbbAXU3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 15:29:21 -0500
From: Semen Protsenko <semen.protsenko@globallogic.com>
To: Roger Quadros <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ARM: OMAP2+: gpmc: make gpmc_cs_get_name() static
Date: Sat, 24 Jan 2015 22:28:39 +0200
Message-Id: <1422131320-1018-2-git-send-email-semen.protsenko@globallogic.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422131320-1018-1-git-send-email-semen.protsenko@globallogic.com>
References: <1422131320-1018-1-git-send-email-semen.protsenko@globallogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning:
  warning: symbol 'gpmc_cs_get_name' was not declared. Should it be static?

Signed-off-by: Semen Protsenko <semen.protsenko@globallogic.com>
---
 drivers/memory/omap-gpmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memory/omap-gpmc.c b/drivers/memory/omap-gpmc.c
index 10eb4ac..db77adb 100644
--- a/drivers/memory/omap-gpmc.c
+++ b/drivers/memory/omap-gpmc.c
@@ -668,7 +668,7 @@ static void gpmc_cs_set_name(int cs, const char *name)
 	gpmc->name = name;
 }
 
-const char *gpmc_cs_get_name(int cs)
+static const char *gpmc_cs_get_name(int cs)
 {
 	struct gpmc_cs_data *gpmc = &gpmc_cs[cs];
 
-- 
1.7.9.5

