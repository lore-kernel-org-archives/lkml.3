Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3DWMjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 08:39:23 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:56567 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab3DWMjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 08:39:20 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.32 with qID r3NCd1Wv025182, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <dwmw2@infradead.org>, <ben@decadent.org.uk>
CC: <romieu@fr.zoreil.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH firmware 2/2] rtl_nic: add firmware rtl8106e-2
Date: Tue, 23 Apr 2013 20:37:48 +0800
Message-ID: <1366720668-4850-2-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1366720668-4850-1-git-send-email-hayeswang@realtek.com>
References: <1366720668-4850-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File: rtl_nic/rtl8106e-2.fw
Version: 0.0.1

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 WHENCE                |   3 +++
 rtl_nic/rtl8106e-2.fw | Bin 0 -> 832 bytes
 2 files changed, 3 insertions(+)
 create mode 100644 rtl_nic/rtl8106e-2.fw

diff --git a/WHENCE b/WHENCE
index 54f6388..fedf031 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1869,6 +1869,9 @@ Version: 0.0.1
 File: rtl_nic/rtl8106e-1.fw
 Version: 0.0.1
 
+File: rtl_nic/rtl8106e-2.fw
+Version: 0.0.1
+
 File: rtl_nic/rtl8168g-1.fw
 Version: 0.0.3
 
diff --git a/rtl_nic/rtl8106e-2.fw b/rtl_nic/rtl8106e-2.fw
new file mode 100644
index 0000000000000000000000000000000000000000..ac042757e1392c184b5b75313d6b597c1561cc41
GIT binary patch
literal 832
zcmYk(!AcuZ6b9fwaZ;g{I7x011aTgqjT0wG%_?9i2wg~*ZqlGa7HUOYrsY~96r><N
zfDLq$M-aN1wNychxa|Y9SlZa7)BoO+Q%rI>neUuAbM74g*xlQFR*M%lp3b-8YFw>F
zaeZz+nX4ttxz7sM7p}K>^>QJJlh#gqZ>`hXZEv;K-mGs#wZ%pfH|lkKT*mu}Sqp^x
z`d@1OHFk2qcSlViY9ilX2abS3y!3F^zSyr=j2T-!t=Jrlbr$jeQQp{cpE;Ug44xP}
zes2Yzjm>eri;SHf)jeR$CXEe7F+Yl6?1sko4cXT{1CZV_^AzqfM8H(~e<nUx_jBWO
zVfxkY#~{0NwI+S;`;?IS{g(W_J?r}-`y@3kH6};m^W{+<mI?N_V9(bd%6_Ilnma_8
z9m@T`)Ecyg*o|6&RuKEEwoTg>`=QpMb;N$Eb!lC(-)ckJP;97nKsyj~XA`>j1p^G|
z1Mx|<8QP3kN$r+)D^^i!)7oN>)sAV$Vnwxp7KlAkyEpfQ+A8Z-rOwTGsk3Kt#^-u{
e!nzZw`=(Z;6~(U9&S+<1*J?dlPps+RJMa%_vcCZU

literal 0
HcmV?d00001

-- 
1.8.1.4

