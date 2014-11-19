Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbaKSL7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 06:59:53 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34695 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbaKSL7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 06:59:51 -0500
From: Johan Hovold <johan@kernel.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bruno Thomsen <bth@kamstrup.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 10/10] net: phy: micrel: add copyright entry
Date: Wed, 19 Nov 2014 12:59:23 +0100
Message-Id: <1416398363-32306-11-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416398363-32306-1-git-send-email-johan@kernel.org>
References: <1416398363-32306-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself to the list of copyright holders.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index d7eb7b0e6d4e..c530de1e63f5 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -6,6 +6,7 @@
  * Author: David J. Choi
  *
  * Copyright (c) 2010-2013 Micrel, Inc.
+ * Copyright (c) 2014 Johan Hovold <johan@kernel.org>
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
-- 
2.0.4

