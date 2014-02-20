Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaBTMwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:52:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:11806 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326AbaBTMvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:51:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,512,1389772800"; 
   d="scan'208";a="486547667"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: Chen-Yu Tsai <wens@csie.org>, Rhyland Klein <rklein@nvidia.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] net: rfkill: gpio: add ACPI IDs for a Broadcom bluetooth chip
Date: Thu, 20 Feb 2014 14:51:37 +0200
Message-Id: <1392900697-27577-5-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.9.0.rc3
In-Reply-To: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds ACPI IDs for Broadcom bluetooth chip BCM43241 used
on various Baytrail based boards such as Lenovo Miix 2 and
Asus Transformer Book T100TA.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 net/rfkill/rfkill-gpio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index ec38884..3a38861 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -157,6 +157,9 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id rfkill_acpi_match[] = {
+	{ "BCM2E1A", RFKILL_TYPE_BLUETOOTH },
+	{ "BCM2E39", RFKILL_TYPE_BLUETOOTH },
+	{ "BCM2E3D", RFKILL_TYPE_BLUETOOTH },
 	{ "BCM4752", RFKILL_TYPE_GPS },
 	{ "LNV4752", RFKILL_TYPE_GPS },
 	{ },
-- 
1.9.0.rc3

