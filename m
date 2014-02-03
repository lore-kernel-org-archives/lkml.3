Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaBCOeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:34:37 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37680 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaBCOef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:34:35 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: JBottomley@parallels.com, trivial@kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] trivial: scsi: Fix warning on make htmldocs caused by scsi_transport_srp.c
Date: Mon,  3 Feb 2014 23:34:25 +0900
Message-Id: <1391438065-22267-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixed following warnings on make htmldocs.

Warning(/drivers/scsi/scsi_transport_srp.c:819):
No description found for parameter 'rport'

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/scsi_transport_srp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index d47ffc8..664eb38 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -811,6 +811,8 @@ EXPORT_SYMBOL_GPL(srp_remove_host);
 /**
  * srp_stop_rport_timers - stop the transport layer recovery timers
  *
+ * @rport: SRP remote port to be removed
+ *
  * Must be called after srp_remove_host() and scsi_remove_host(). The caller
  * must hold a reference on the rport (rport->dev) and on the SCSI host
  * (rport->dev.parent).
-- 
1.9.rc1

