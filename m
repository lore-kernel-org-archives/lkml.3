Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaGGWcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:32:39 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56018 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbaGGWcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:32:05 -0400
X-Originating-IP: 78.210.48.61
From: Guillaume Clement <gclement@baobob.org>
To: Julian Andres Klode <jak@jak-linux.org>, Marc Dietrich <marvin24@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ac100@lists.launchpad.net, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 5/5] staging:nvec: Add missing blank line after declarations.
Date: Tue,  8 Jul 2014 00:31:37 +0200
Message-Id: <1404772297-6549-6-git-send-email-gclement@baobob.org>
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
 drivers/staging/nvec/nvec_ps2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/nvec/nvec_ps2.c b/drivers/staging/nvec/nvec_ps2.c
index 45b2f13..f56f1db 100644
--- a/drivers/staging/nvec/nvec_ps2.c
+++ b/drivers/staging/nvec/nvec_ps2.c
@@ -53,12 +53,14 @@ static struct nvec_ps2 ps2_dev;
 static int ps2_startstreaming(struct serio *ser_dev)
 {
 	unsigned char buf[] = { NVEC_PS2, AUTO_RECEIVE_N, PACKET_SIZE };
+
 	return nvec_write_async(ps2_dev.nvec, buf, sizeof(buf));
 }
 
 static void ps2_stopstreaming(struct serio *ser_dev)
 {
 	unsigned char buf[] = { NVEC_PS2, CANCEL_AUTO_RECEIVE };
+
 	nvec_write_async(ps2_dev.nvec, buf, sizeof(buf));
 }
 
-- 
1.8.5.5

