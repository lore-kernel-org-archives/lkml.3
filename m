Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaGGWc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:32:56 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38810 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaGGWcE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:32:04 -0400
X-Originating-IP: 78.210.48.61
From: Guillaume Clement <gclement@baobob.org>
To: Julian Andres Klode <jak@jak-linux.org>, Marc Dietrich <marvin24@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ac100@lists.launchpad.net, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 4/5] staging:nvec: Add missing blank line after declarations.
Date: Tue,  8 Jul 2014 00:31:36 +0200
Message-Id: <1404772297-6549-5-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1404772297-6549-1-git-send-email-gclement@baobob.org>
References: <1404772297-6549-1-git-send-email-gclement@baobob.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guillaume Clément <gclement@baobob.org>
---
 drivers/staging/nvec/nvec_power.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/nvec/nvec_power.c b/drivers/staging/nvec/nvec_power.c
index aacfcd6..6446e15 100644
--- a/drivers/staging/nvec/nvec_power.c
+++ b/drivers/staging/nvec/nvec_power.c
@@ -226,6 +226,7 @@ static int nvec_power_get_property(struct power_supply *psy,
 				   union power_supply_propval *val)
 {
 	struct nvec_power *power = dev_get_drvdata(psy->dev->parent);
+
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
 		val->intval = power->on;
-- 
1.8.5.5

