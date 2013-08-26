Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab3HZPL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:11:28 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:40243 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841Ab3HZPLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:22 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/24] Staging: winbond: phy_calibration: fixed some lines over 80 characters
Date: Mon, 26 Aug 2013 17:10:04 +0200
Message-Id: <1377529823-5116-6-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second of the patches that fixes the lines over 80 characters in phy_calibration.c

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/phy_calibration.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index 6635c85..a4f3773 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -1233,8 +1233,10 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 		b_2 = (rot_image_q_b * 32768) / rot_tone_i_b -
 			phw_data->iq_rsdl_phase_tx_d2;
 
-		PHY_DEBUG(("[CAL]    ** iq_rsdl_gain_tx_d2 = %d\n", phw_data->iq_rsdl_gain_tx_d2));
-		PHY_DEBUG(("[CAL]    ** iq_rsdl_phase_tx_d2= %d\n", phw_data->iq_rsdl_phase_tx_d2));
+		PHY_DEBUG(("[CAL]    ** iq_rsdl_gain_tx_d2 = %d\n",
+				   phw_data->iq_rsdl_gain_tx_d2));
+		PHY_DEBUG(("[CAL]    ** iq_rsdl_phase_tx_d2= %d\n",
+				   phw_data->iq_rsdl_phase_tx_d2));
 		PHY_DEBUG(("[CAL]    ***** EPSILON/2 = %d\n", a_2));
 		PHY_DEBUG(("[CAL]    ***** THETA/2   = %d\n", b_2));
 
@@ -1280,7 +1282,8 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 
 		/* e. */
 		pwr_tone = (iqcal_tone_i*iqcal_tone_i + iqcal_tone_q*iqcal_tone_q);
-		pwr_image = (iqcal_image_i*iqcal_image_i + iqcal_image_q*iqcal_image_q)*factor;
+		pwr_image = (iqcal_image_i*iqcal_image_i +
+				   iqcal_image_q*iqcal_image_q)*factor;
 
 		PHY_DEBUG(("[CAL]    ** pwr_tone  = %d\n", pwr_tone));
 		PHY_DEBUG(("[CAL]    ** pwr_image  = %d\n", pwr_image));
@@ -1577,7 +1580,8 @@ unsigned char adjust_TXVGA_for_iq_mag(struct hw_data *phw_data)
 
 		sqsum = iqcal_tone_i0*iqcal_tone_i0 + iqcal_tone_q0*iqcal_tone_q0;
 		iq_mag_0_tx = (s32) _sqrt(sqsum);
-		PHY_DEBUG(("[CAL]    ** auto_adjust_txvga_for_iq_mag_0_tx=%d\n", iq_mag_0_tx));
+		PHY_DEBUG(("[CAL]    ** auto_adjust_txvga_for_iq_mag_0_tx=%d\n",
+				   iq_mag_0_tx));
 
 		if (iq_mag_0_tx >= 700 && iq_mag_0_tx <= 1750)
 			break;
-- 
1.8.1.2

