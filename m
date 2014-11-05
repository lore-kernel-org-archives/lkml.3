Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbaKEPeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:34:08 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:49154 "EHLO
	vsp-authed-04-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212AbaKEPeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:34:05 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: Sandeep Nair <sandeep_n@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, software@gaisler.com
Subject: [PATCH] soc: Include drivers/soc/Kconfig only once
Date: Wed,  5 Nov 2014 16:32:22 +0100
Message-Id: <1415201542-29758-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 drivers/Kconfig |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 1a693d3..622fa26 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -148,8 +148,6 @@ source "drivers/remoteproc/Kconfig"
 
 source "drivers/rpmsg/Kconfig"
 
-source "drivers/soc/Kconfig"
-
 source "drivers/devfreq/Kconfig"
 
 source "drivers/extcon/Kconfig"
-- 
1.7.10.4

