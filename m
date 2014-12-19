Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaLSJTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:19:41 -0500
Received: from mail-yk0-f170.google.com ([209.85.160.170]:43168 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaLSJTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:19:39 -0500
From: Sage Vaillancourt <sagev9000@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, chase.southwood@gmail.com,
        ebru.akagunduz@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sage Vaillancourt <sagev9000@gmail.com>
Subject: [PATCH 544/544] Staging: comedi: fix spacing style issues in ni_stc.h This is a patch to the ni_stc.h file that removes spaces before tabs, and adds blank lines after declarations. 
Date: Fri, 19 Dec 2014 04:19:31 -0500
Message-Id: <1418980771-17690-1-git-send-email-sagev9000@gmail.com>
X-Mailer: git-send-email 2.2.0
Signed-off-by: Sage Vaillancourt <sagev9000@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/comedi/drivers/ni_stc.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_stc.h b/drivers/staging/comedi/drivers/ni_stc.h
index bd69c3f..a79fd07 100644
--- a/drivers/staging/comedi/drivers/ni_stc.h
+++ b/drivers/staging/comedi/drivers/ni_stc.h
@@ -166,7 +166,7 @@ enum Interrupt_B_Ack_Bits {
 #define AI_SCAN_IN_PROG_Pulse			_bit4
 #define AI_EXTMUX_CLK_Pulse			_bit3
 #define AI_LOCALMUX_CLK_Pulse			_bit2
-#define AI_SC_TC_Pulse			 	_bit1
+#define AI_SC_TC_Pulse				_bit1
 #define AI_CONVERT_Pulse			_bit0
 
 #define AO_Command_1_Register		9
@@ -326,6 +326,7 @@ static inline unsigned RTSI_Output_Bit(unsigned channel, int is_mseries)
 {
 	unsigned max_channel;
 	unsigned base_bit_shift;
+
 	if (is_mseries) {
 		base_bit_shift = 8;
 		max_channel = 7;
@@ -642,7 +643,7 @@ static unsigned AO_UPDATE_Output_Select(enum ao_update_output_selection
 #define G_Load_Source_Select		_bit7
 #define G_Reload_Source_Switching	_bit15
 #define G_Loading_On_Gate		_bit14
-#define G_Gate_Polarity 		_bit13
+#define G_Gate_Polarity			_bit13
 
 #define G_Counting_Once(a)		(((a)&0x03)<<10)
 #define G_Stop_Mode(a)			(((a)&0x03)<<5)
@@ -1142,6 +1143,7 @@ static inline unsigned MSeries_AI_Config_Bank_Bits(enum ni_reg_type reg_type,
 						   unsigned channel)
 {
 	unsigned bits = channel & 0x30;
+
 	if (reg_type == ni_reg_622x) {
 		if (channel & 0x40)
 			bits |= 0x400;
@@ -1191,6 +1193,7 @@ enum MSeries_PLL_Control_Bits {
 static inline unsigned MSeries_PLL_Divisor_Bits(unsigned divisor)
 {
 	static const unsigned max_divisor = 0x10;
+
 	if (divisor < 1 || divisor > max_divisor) {
 		pr_err("%s: bug, invalid divisor=%i\n", __func__, divisor);
 		return 0;
@@ -1201,6 +1204,7 @@ static inline unsigned MSeries_PLL_Divisor_Bits(unsigned divisor)
 static inline unsigned MSeries_PLL_Multiplier_Bits(unsigned multiplier)
 {
 	static const unsigned max_multiplier = 0x100;
+
 	if (multiplier < 1 || multiplier > max_multiplier) {
 		pr_err("%s: bug, invalid multiplier=%i\n", __func__,
 		       multiplier);
-- 
2.2.0

