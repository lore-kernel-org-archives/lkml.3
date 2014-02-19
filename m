Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbaBSQhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:37:13 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.150]:60657 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542AbaBSQhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:37:09 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-11.tower-178.messagelabs.com!1392827826!27197945!2
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201402191636.s1JGarhP017640@swsrvapps-02.lan>
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Date: Wed, 19 Feb 2014 16:32:46 +0000
Subject: [PATCH V1 1/3] include/linux/mfd/da9052/da9052: Add new BC chip
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
CC: David Jander <david@protonic.nl>, Liam Girdwood <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the hash define for the new variant of the DA9053 PMIC called BC.

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
---

This patch is relative to linux-next repository tag next-20140219

This patch must be applied before the others in this patch series
or the drivers that the other patches modify will not compile.

 include/linux/mfd/da9052/da9052.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
index 21e21b8..bba65f5 100644
--- a/include/linux/mfd/da9052/da9052.h
+++ b/include/linux/mfd/da9052/da9052.h
@@ -83,6 +83,7 @@ enum da9052_chip_id {
 	DA9053_AA,
 	DA9053_BA,
 	DA9053_BB,
+	DA9053_BC,
 };
 
 struct da9052_pdata;
-- 
end-of-patch 1/3 for PATCH V1

