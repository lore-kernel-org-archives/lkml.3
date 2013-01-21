Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3AUVOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:14:04 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:38858 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3AUVOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:14:01 -0500
From: Laurent Navet <laurent.navet@gmail.com>
To: linux-pcmcia@lists.infradead.org
Cc: plagnioj@jcrosoft.com, gregkh@linuxfoundation.org, nicolas.ferre@atmel.com,
        wfp5p@virginia.edu, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH 1/3] drivers: pcmcia: at91_cf.c fix checkpatch error
Date: Mon, 21 Jan 2013 22:16:04 +0100
Message-Id: <1358802966-10430-2-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358802966-10430-1-git-send-email-laurent.navet@gmail.com>
References: <1358802966-10430-1-git-send-email-laurent.navet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix this checkpatch error:
- ERROR: switch and case should be at the same indent

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/pcmcia/at91_cf.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index 01463c7..918be53 100644
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -120,14 +120,14 @@ at91_cf_set_socket(struct pcmcia_socket *sock, struct socket_state_t *s)
 	/* switch Vcc if needed and possible */
 	if (gpio_is_valid(cf->board->vcc_pin)) {
 		switch (s->Vcc) {
-			case 0:
-				gpio_set_value(cf->board->vcc_pin, 0);
-				break;
-			case 33:
-				gpio_set_value(cf->board->vcc_pin, 1);
-				break;
-			default:
-				return -EINVAL;
+		case 0:
+			gpio_set_value(cf->board->vcc_pin, 0);
+			break;
+		case 33:
+			gpio_set_value(cf->board->vcc_pin, 1);
+			break;
+		default:
+			return -EINVAL;
 		}
 	}
 
-- 
1.7.10.4

