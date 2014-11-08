Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaKHVPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 16:15:01 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:57494 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaKHVO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 16:14:59 -0500
From: Krzysztof Konopko <kris@konagma.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: navin patidar <navin.patidar@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, trivial@kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Krzysztof Konopko <kris@konagma.com>
Subject: [PATCH] rtl8188eu: Remove unnecessary braces for simple return in xmit_linux.c
Date: Sat,  8 Nov 2014 22:14:13 +0100
Message-Id: <1415481253-12281-1-git-send-email-kris@konagma.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/checkpatch.pl reports a coding style problem in xmit_linux.c

  WARNING:BRACES: braces {} are not necessary for single statement blocks
  #61852: FILE: rtl8188eu/os_dep/xmit_linux.c:70:

This patch removes unnecessary braces.

Signed-off-by: Krzysztof Konopko <kris@konagma.com>
---
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
index d5e41a5..9e0e338 100644
--- a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
@@ -67,9 +67,8 @@ uint _rtw_pktfile_read(struct pkt_file *pfile, u8 *rmem, uint rlen)
 int rtw_endofpktfile(struct pkt_file *pfile)
 {
 
-	if (pfile->pkt_len == 0) {
+	if (pfile->pkt_len == 0)
 		return true;
-	}
 
 
 	return false;
-- 
2.1.1

