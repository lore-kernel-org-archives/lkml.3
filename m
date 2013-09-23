Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3IWPV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:21:56 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.109]:16600 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176Ab3IWPVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:21:54 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-9.tower-193.messagelabs.com!1379949711!13854659!2
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 23 Sep 2013 17:21:52 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: <linux-edac@vger.kernel.org>
CC: Borislav Petkov <bp@alien8.de>, Dave Jiang <dave.jiang@gmail.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Chunhe Lan <Chunhe.Lan@freescale.com>, <linux-kernel@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH 1/3] MAINTAINERS: Add edac-mpc85xx driver to MAINTAINERS
Date: Mon, 23 Sep 2013 17:23:27 +0200
Message-ID: <1379949809-11083-2-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379949809-11083-1-git-send-email-johannes.thumshirn@men.de>
References: <1379949809-11083-1-git-send-email-johannes.thumshirn@men.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 23 Sep 2013 15:21:52.0006 (UTC) FILETIME=[A12A1260:01CEB870]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add drivers/edac/mpc85xx_edac.[ch] to MAINTAINERS file and me as maintainer.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Dave Jiang <dave.jiang@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e61c2e8..9c400b4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3097,6 +3097,13 @@ W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/i82975x_edac.c
 
+EDAC-MPC85XX
+M:	Johannes Thumshirn <johannes.thumshirn@men.de>
+L:	linux-edac@vger.kernel.org
+W:	bluesmoke.sourceforge.net
+S:	Maintained
+F:	drivers/edac/mpc85xx_edac.[ch]
+
 EDAC-PASEMI
 M:	Egor Martovetsky <egor@pasemi.com>
 L:	linux-edac@vger.kernel.org
-- 
1.7.9.5

