Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbaCKKTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:19:09 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:44711 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbaCKKLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:11:25 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Simon Horman <horms+renesas@verge.net.au>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-serial@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 2/4] serial: sh-sci: Remove useless casts
Date: Tue, 11 Mar 2014 11:11:18 +0100
Message-Id: <1394532680-4264-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394532680-4264-1-git-send-email-geert@linux-m68k.org>
References: <1394532680-4264-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/tty/serial/sh-sci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 24ec6ef67984..4529dbca2287 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -2423,25 +2423,25 @@ struct sci_port_info {
 static const struct of_device_id of_sci_match[] = {
 	{
 		.compatible = "renesas,scif",
-		.data = (void *)&(const struct sci_port_info) {
+		.data = &(const struct sci_port_info) {
 			.type = PORT_SCIF,
 			.regtype = SCIx_SH4_SCIF_REGTYPE,
 		},
 	}, {
 		.compatible = "renesas,scifa",
-		.data = (void *)&(const struct sci_port_info) {
+		.data = &(const struct sci_port_info) {
 			.type = PORT_SCIFA,
 			.regtype = SCIx_SCIFA_REGTYPE,
 		},
 	}, {
 		.compatible = "renesas,scifb",
-		.data = (void *)&(const struct sci_port_info) {
+		.data = &(const struct sci_port_info) {
 			.type = PORT_SCIFB,
 			.regtype = SCIx_SCIFB_REGTYPE,
 		},
 	}, {
 		.compatible = "renesas,hscif",
-		.data = (void *)&(const struct sci_port_info) {
+		.data = &(const struct sci_port_info) {
 			.type = PORT_HSCIF,
 			.regtype = SCIx_HSCIF_REGTYPE,
 		},
-- 
1.7.9.5

