Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaCJVfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:35:32 -0400
Received: from xes-mad.com ([216.165.139.218]:17749 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406AbaCJVf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:35:29 -0400
From: Peter Tyser <ptyser@xes-inc.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Tyser <ptyser@xes-inc.com>, Guenter Roeck <linux@roeck-us.net>,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: [PATCH 6/8] mfd: lpc_ich: Change Avoton to iTCO v3
Date: Mon, 10 Mar 2014 16:34:56 -0500
Message-Id: <1394487298-14459-6-git-send-email-ptyser@xes-inc.com>
X-Mailer: git-send-email 1.7.7.GIT
In-Reply-To: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The register layout of the Avoton is compatible with the iTCO v3
register layout.

Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Tested-by: Rajat Jain <rajatjain@juniper.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: James Ralston <james.d.ralston@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org
---
 drivers/mfd/lpc_ich.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index b4bfc58..cb655b3 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -502,7 +502,7 @@ static struct lpc_ich_info lpc_chipset_info[] = {
 	},
 	[LPC_AVN] = {
 		.name = "Avoton SoC",
-		.iTCO_version = 1,
+		.iTCO_version = 3,
 	},
 	[LPC_COLETO] = {
 		.name = "Coleto Creek",
-- 
1.7.7.GIT

