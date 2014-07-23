Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbaGWOts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:49:48 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:48537 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973AbaGWOtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:49:46 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] staging:bcm:Transmit.c:coding style:line over 80 char
Date: Wed, 23 Jul 2014 20:19:12 +0530
Message-Id: <1406126952-12726-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/staging/bcm/Transmit.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/bcm/Transmit.c b/drivers/staging/bcm/Transmit.c
index 05fae92..622a482 100644
--- a/drivers/staging/bcm/Transmit.c
+++ b/drivers/staging/bcm/Transmit.c
@@ -89,7 +89,8 @@ int SendControlPacket(struct bcm_mini_adapter *Adapter, char *pControlPacket)
  * to the target via the host h/w interface.
  * @return  zero(success) or -ve value(failure)
  */
-int SetupNextSend(struct bcm_mini_adapter *Adapter,  struct sk_buff *Packet, USHORT Vcid)
+int SetupNextSend(struct bcm_mini_adapter *Adapter,
+		struct sk_buff *Packet, USHORT Vcid)
 {
 	int	status = 0;
 	bool	bHeaderSupressionEnabled = false;
@@ -205,7 +206,9 @@ int tx_pkt_handler(struct bcm_mini_adapter *Adapter)
 	int status = 0;
 
 	while (!kthread_should_stop()) {
-		/* FIXME - the timeout looks like workaround for racey usage of TxPktAvail */
+		/* FIXME - the timeout looks like workaround
+		 *  for racey usage of TxPktAvail
+		*/
 		if (Adapter->LinkUpStatus)
 			wait_event_timeout(Adapter->tx_packet_wait_queue,
 					   tx_pending(Adapter),
@@ -229,7 +232,8 @@ int tx_pkt_handler(struct bcm_mini_adapter *Adapter)
 		if (Adapter->bEndPointHalted == TRUE) {
 			Bcm_clear_halt_of_endpoints(Adapter);
 			Adapter->bEndPointHalted = false;
-			StartInterruptUrb((struct bcm_interface_adapter *)(Adapter->pvInterfaceAdapter));
+			StartInterruptUrb((struct bcm_interface_adapter *)
+					(Adapter->pvInterfaceAdapter));
 		}
 
 		if (Adapter->LinkUpStatus && !Adapter->IdleMode) {
-- 
1.8.1.2

