Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934463AbaGRJcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:32:21 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56597 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934274AbaGRJcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:32:12 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 1/9] usb: musb: core: cleanup - remove some useless 'break's from switch statements
Date: Fri, 18 Jul 2014 11:31:22 +0200
Message-Id: <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/usb/musb/musb_core.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index b841ee0..8623112 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -680,7 +680,6 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 		default:
 			/* "should not happen" */
 			musb->is_active = 0;
-			break;
 		}
 	}
 
@@ -737,7 +736,6 @@ b_host:
 				if (hcd)
 					hcd->self.is_b_host = 0;
 			}
-			break;
 		}
 
 		musb_host_poke_root_hub(musb);
@@ -787,7 +785,6 @@ b_host:
 		default:
 			WARNING("unhandled DISCONNECT transition (%s)\n",
 				usb_otg_state_string(musb->xceiv->state));
-			break;
 		}
 	}
 
@@ -2015,7 +2012,6 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 		break;
 	default:
 		dev_err(dev, "unsupported port mode %d\n", musb->port_mode);
-		break;
 	}
 
 	if (status < 0)
-- 
1.7.10.4

