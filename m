Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965020Ab3GQW4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:56:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56650 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964954Ab3GQWzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Magnus Damm <damm@opensource.se>,
        Simon Horman <horms+renesas@verge.net.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 112/145] ARM: shmobile: emev2 GIO3 resource fix
Date: Wed, 17 Jul 2013 15:47:24 -0700
Message-Id: <1374101277-7915-113-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Damm <damm@opensource.se>

commit 1eb14ea1e6bcd11d6d0ba937fc39808bb4d3453e upstream.

Fix GIO3 base addresses for EMEV2.

This bug was introduced by 088efd9273b5076a0aead479aa31f1066d182b3e
("mach-shmobile: Emma Mobile EV2 GPIO support V3") which was included in v3.5.

Signed-off-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-shmobile/setup-emev2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-shmobile/setup-emev2.c b/arch/arm/mach-shmobile/setup-emev2.c
index a47beeb..c02a9fd 100644
--- a/arch/arm/mach-shmobile/setup-emev2.c
+++ b/arch/arm/mach-shmobile/setup-emev2.c
@@ -287,14 +287,14 @@ static struct gpio_em_config gio3_config = {
 static struct resource gio3_resources[] = {
 	[0] = {
 		.name	= "GIO_096",
-		.start	= 0xe0050100,
-		.end	= 0xe005012b,
+		.start	= 0xe0050180,
+		.end	= 0xe00501ab,
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
 		.name	= "GIO_096",
-		.start	= 0xe0050140,
-		.end	= 0xe005015f,
+		.start	= 0xe00501c0,
+		.end	= 0xe00501df,
 		.flags	= IORESOURCE_MEM,
 	},
 	[2] = {
-- 
1.8.1.2

