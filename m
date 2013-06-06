Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab3FFI1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:27:14 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:57424 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab3FFI1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:27:11 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-pcmcia@lists.infradead.org>, <linux@dominikbrodowski.net>,
        <manabian@gmail.com>, <fabio.porcedda@gmail.com>,
        <laurent.navet@gmail.com>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v3 7/7] pcmcia/trivial: at91_cf: fix checkpatch error
Date: Thu, 6 Jun 2013 10:24:20 +0200
Message-ID: <a132c622362cc90434f2a744a5cf2c3b22e86b58.1370506678.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1370506678.git.nicolas.ferre@atmel.com>
References: <cover.1370506678.git.nicolas.ferre@atmel.com>
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
1.8.2.2

