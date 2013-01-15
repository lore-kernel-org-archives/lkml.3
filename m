Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab3AOSxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:53:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:34213 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757778Ab3AOSw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:52:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 023/221] ath9k_hw: Fix RX gain initvals for AR9485
Date: Tue, 15 Jan 2013 10:49:10 -0800
Message-Id: <20130115184959.720171121@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit a796a1dd5da9645ad77aa687d1a890ecd63ab5a6 upstream.

Populate iniModesRxGain with the correct initvals
array for AR9485 v1.1

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -540,7 +540,7 @@ static void ar9003_rx_gain_table_mode0(s
 				ar9340Common_rx_gain_table_1p0);
 	else if (AR_SREV_9485_11(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
-				ar9485Common_wo_xlna_rx_gain_1_1);
+			       ar9485_common_rx_gain_1_1);
 	else if (AR_SREV_9550(ah)) {
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 				ar955x_1p0_common_rx_gain_table);


