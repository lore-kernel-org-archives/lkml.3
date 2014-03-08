Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaCHTin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 14:38:43 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:63212 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaCHTil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 14:38:41 -0500
Date: Sat, 8 Mar 2014 14:38:38 -0500
From: Conrad Meyer <cemeyer@uw.edu>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: Fix 80-char line limit style issue in
 addi_apci_1500.c
Message-ID: <20140308143838.19e2a640@m>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix minor checkpatch.pl style issues (80-char line limits) in
addi_apci_1500.c.

Signed-off-by: Conrad Meyer <cse.cem@gmail.com>
---
 drivers/staging/comedi/drivers/addi_apci_1500.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1500.c b/drivers/staging/comedi/drivers/addi_apci_1500.c
index 74f7ace..f23ca3d 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1500.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1500.c
@@ -26,11 +26,13 @@ static const struct addi_board apci1500_boardtypes[] = {
                .di_read                = i_APCI1500_Initialisation,
                .di_write               = i_APCI1500_StartStopInputEvent,
                .di_bits                = apci1500_di_insn_bits,
-               .do_config              = i_APCI1500_ConfigDigitalOutputErrorInterrupt,
+               .do_config              =
+                       i_APCI1500_ConfigDigitalOutputErrorInterrupt,
                .do_write               = i_APCI1500_WriteDigitalOutput,
                .do_bits                = i_APCI1500_ConfigureInterrupt,
                .timer_config           = i_APCI1500_ConfigCounterTimerWatchdog,
-               .timer_write            = i_APCI1500_StartStopTriggerTimerCounterWatchdog,
+               .timer_write            =
+                       i_APCI1500_StartStopTriggerTimerCounterWatchdog,
                .timer_read             = i_APCI1500_ReadInterruptMask,
                .timer_bits             = i_APCI1500_ReadCounterTimerWatchdog,
        },
--
1.8.5.3


