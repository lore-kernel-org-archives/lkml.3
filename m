Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839Ab3CULlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:41:20 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:7924 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298Ab3CULlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:41:17 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-pcmcia@lists.infradead.org>, <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>, <manabian@gmail.com>,
        <fabio.porcedda@gmail.com>, <laurent.navet@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 7/7] pcmcia/trivial: at91_cf: fix checkpatch error
Date: Thu, 21 Mar 2013 12:40:17 +0100
Message-ID: <c1435f58cfd59c8e49d36a04a597543bb0a330d3.1363865228.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1363865228.git.nicolas.ferre@atmel.com>
References: <cover.1363865228.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Navet <laurent.navet@gmail.com>

fix this checkpatch error:
- ERROR: switch and case should be at the same indent

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/pcmcia/at91_cf.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index 8ddc57c..b8f5acf 100644
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -119,14 +119,14 @@ at91_cf_set_socket(struct pcmcia_socket *sock, struct socket_state_t *s)
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
1.8.0

