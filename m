Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3GIM5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:57:07 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8129 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3GIM5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:57:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 09 Jul 2013 05:57:43 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <cw00.choi@samsung.com>, <myungjoo.ham@samsung.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <rob@landley.net>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/4] extcon: palmas: remove unused member from palams_usb structure
Date: Tue, 9 Jul 2013 18:34:21 +0530
Message-ID: <1373375064-12012-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1373375064-12012-1-git-send-email-ldewangan@nvidia.com>
References: <1373375064-12012-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused member vbus_enable and set_vbus_work from palmas_usb
as these members are not used in drivers.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 include/linux/mfd/palmas.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 1a8dd7a..03c22ca 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -371,16 +371,11 @@ struct palmas_usb {
 
 	struct extcon_dev edev;
 
-	/* used to set vbus, in atomic path */
-	struct work_struct set_vbus_work;
-
 	int id_otg_irq;
 	int id_irq;
 	int vbus_otg_irq;
 	int vbus_irq;
 
-	int vbus_enable;
-
 	enum palmas_usb_state linkstat;
 };
 
-- 
1.7.1.1

