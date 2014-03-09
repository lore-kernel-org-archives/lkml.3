Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaCIH22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 03:28:28 -0400
Received: from [172.245.23.124] ([172.245.23.124]:35091 "EHLO
	w1-ca.frizzlehost.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaCIH2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 03:28:24 -0400
From: Fred Akers <knivey@botops.net>
To: gregkh@linuxfoundation.org, abbotti@mev.co.uk,
        hsweeten@visionengravers.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fred Akers <knivey@botops.net>
Subject: [PATCH] Staging: comedi: apci_1564: Fix long CamelCase function names
Date: Sun,  9 Mar 2014 03:26:49 -0400
Message-Id: <1394350009-23464-1-git-send-email-knivey@botops.net>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a few function names that are very long and are
not in the correct naming style

Signed-off-by: Fred Akers <knivey@botops.net>
---
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 62 ++++++++++------------
 drivers/staging/comedi/drivers/addi_apci_1564.c    | 16 +++---
 2 files changed, 36 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index a31e115..cb426e7 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -116,7 +116,7 @@ static unsigned int ui_InterruptData, ui_Type;
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1564_ConfigDigitalInput                      |
+| Function   Name   : int i_apci1564_di_config                      |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -141,10 +141,9 @@ static unsigned int ui_InterruptData, ui_Type;
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1564_ConfigDigitalInput(struct comedi_device *dev,
-					 struct comedi_subdevice *s,
-					 struct comedi_insn *insn,
-					 unsigned int *data)
+static int i_apci1564_di_config(struct comedi_device *dev,
+				struct comedi_subdevice *s,
+				struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 
@@ -184,7 +183,7 @@ static int apci1564_di_insn_bits(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1564_ConfigDigitalOutput                     |
+| Function   Name   : int i_apci1564_do_config                     |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -207,10 +206,9 @@ static int apci1564_di_insn_bits(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1564_ConfigDigitalOutput(struct comedi_device *dev,
-					  struct comedi_subdevice *s,
-					  struct comedi_insn *insn,
-					  unsigned int *data)
+static int i_apci1564_do_config(struct comedi_device *dev,
+				struct comedi_subdevice *s,
+				struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command = 0;
@@ -261,7 +259,7 @@ static int apci1564_do_insn_bits(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1564_ConfigTimerCounterWatchdog              |
+| Function   Name   : int i_apci1564_timer_config              |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -289,10 +287,9 @@ static int apci1564_do_insn_bits(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
-						 struct comedi_subdevice *s,
-						 struct comedi_insn *insn,
-						 unsigned int *data)
+static int i_apci1564_timer_config(struct comedi_device *dev,
+				   struct comedi_subdevice *s,
+				   struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
@@ -384,7 +381,7 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1564_StartStopWriteTimerCounterWatchdog      |
+| Function   Name   : int i_apci1564_timer_write      |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -408,10 +405,9 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *dev,
-							 struct comedi_subdevice *s,
-							 struct comedi_insn *insn,
-							 unsigned int *data)
+static int i_apci1564_timer_write(struct comedi_device *dev,
+				  struct comedi_subdevice *s,
+				  struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
@@ -472,7 +468,7 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1564_ReadTimerCounterWatchdog                |
+| Function   Name   : int i_apci1564_timer_read                |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -491,10 +487,9 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
-					       struct comedi_subdevice *s,
-					       struct comedi_insn *insn,
-					       unsigned int *data)
+static int i_apci1564_timer_read(struct comedi_device *dev,
+				 struct comedi_subdevice *s,
+				 struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
@@ -539,7 +534,7 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   :  int i_APCI1564_ReadInterruptStatus                    |
+| Function   Name   :  int i_apci1564_do_read                    |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -554,10 +549,9 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 +----------------------------------------------------------------------------+
 */
 
-static int i_APCI1564_ReadInterruptStatus(struct comedi_device *dev,
-					  struct comedi_subdevice *s,
-					  struct comedi_insn *insn,
-					  unsigned int *data)
+static int i_apci1564_do_read(struct comedi_device *dev,
+			      struct comedi_subdevice *s,
+			      struct comedi_insn *insn, unsigned int *data)
 {
 	*data = ui_Type;
 	return insn->n;
@@ -565,7 +559,7 @@ static int i_APCI1564_ReadInterruptStatus(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : static void v_APCI1564_Interrupt					     |
+| Function   Name   : static void v_apci1564_interrupt					     |
 |					  (int irq , void *d)      |
 +----------------------------------------------------------------------------+
 | Task              : Interrupt handler for the interruptible digital inputs |
@@ -580,7 +574,7 @@ static int i_APCI1564_ReadInterruptStatus(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static void v_APCI1564_Interrupt(int irq, void *d)
+static void v_apci1564_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct addi_private *devpriv = dev->private;
@@ -724,7 +718,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1564_Reset(struct comedi_device *dev)               |                                                       |
+| Function   Name   : int i_apci1564_reset(struct comedi_device *dev)               |                                                       |
 +----------------------------------------------------------------------------+
 | Task              :resets all the registers                                |
 +----------------------------------------------------------------------------+
@@ -737,7 +731,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 +----------------------------------------------------------------------------+
 */
 
-static int i_APCI1564_Reset(struct comedi_device *dev)
+static int i_apci1564_reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 6248284..801e852 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -21,16 +21,16 @@ static const struct addi_board apci1564_boardtypes[] = {
 		.i_NbrDoChannel		= 32,
 		.i_DoMaxdata		= 0xffffffff,
 		.i_Timer		= 1,
-		.interrupt		= v_APCI1564_Interrupt,
-		.reset			= i_APCI1564_Reset,
-		.di_config		= i_APCI1564_ConfigDigitalInput,
+		.interrupt		= v_apci1564_interrupt,
+		.reset			= i_apci1564_reset,
+		.di_config		= i_apci1564_di_config,
 		.di_bits		= apci1564_di_insn_bits,
-		.do_config		= i_APCI1564_ConfigDigitalOutput,
+		.do_config		= i_apci1564_do_config,
 		.do_bits		= apci1564_do_insn_bits,
-		.do_read		= i_APCI1564_ReadInterruptStatus,
-		.timer_config		= i_APCI1564_ConfigTimerCounterWatchdog,
-		.timer_write		= i_APCI1564_StartStopWriteTimerCounterWatchdog,
-		.timer_read		= i_APCI1564_ReadTimerCounterWatchdog,
+		.do_read		= i_apci1564_do_read,
+		.timer_config		= i_apci1564_timer_config,
+		.timer_write		= i_apci1564_timer_write,
+		.timer_read		= i_apci1564_timer_read,
 	},
 };
 
-- 
1.8.5.3

