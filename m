Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3DWMjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 08:39:22 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:56568 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab3DWMjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 08:39:20 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.32 with qID r3NCcijc024916, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <dwmw2@infradead.org>, <ben@decadent.org.uk>
CC: <romieu@fr.zoreil.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH firmware 1/2] rtl_nic: Add firmware rtl8168g-3
Date: Tue, 23 Apr 2013 20:37:47 +0800
Message-ID: <1366720668-4850-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File: rtl_nic/rtl8168g-3.fw
Version: 0.0.1

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 WHENCE                |   5 ++++-
 rtl_nic/rtl8168g-3.fw | Bin 0 -> 832 bytes
 2 files changed, 4 insertions(+), 1 deletion(-)
 create mode 100644 rtl_nic/rtl8168g-3.fw

diff --git a/WHENCE b/WHENCE
index 013f810..54f6388 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1875,8 +1875,11 @@ Version: 0.0.3
 File: rtl_nic/rtl8168g-2.fw
 Version: 0.0.1
 
+File: rtl_nic/rtl8168g-3.fw
+Version: 0.0.1
+
 Licence:
- * Copyright © 2011, Realtek Semiconductor Corporation
+ * Copyright © 2011-2013, Realtek Semiconductor Corporation
  *
  * Permission is hereby granted for the distribution of this firmware
  * data in hexadecimal or equivalent format, provided this copyright
diff --git a/rtl_nic/rtl8168g-3.fw b/rtl_nic/rtl8168g-3.fw
new file mode 100644
index 0000000000000000000000000000000000000000..0c97d7ea1437ba515c1dbdabe8aa285e79585786
GIT binary patch
literal 832
zcmYk(!AcuZ6b9fwaZ*7`oFrF-f;bOQ<D^r9W))Bhg)T~$ZqlHoS+pvWWsqx0KoCKE
z04sFkBM5G0Ep4Hc(rq80MX|9<r~kbtM@(`#neUuAbM74g*zUettkoCa&L^$78dqyk
z{B+?-vQSHybDx)7=UiR9dQnf}q_x%Vu60`5?f0#<&Gk1?ZK;vOjU>Urb9|Vbvp~qN
z|E1PnV=D*za?}K(Ch{liz#&kGmnY`zv)zitn6cHfip{}TXA%D&=8Y|%Fh?_t!DC~`
z@2%jIu{o}t$k<1tx(AHel(E4m=0_2Xz0ml+A^W;#0Mc7#p22N~2$)IlX5w>oKbJli
zrl0+O46<8SYtj|pr-an+x8(2bTi+MiN2zhCF*y>SFOTxDOt8mS_I$lp_A~v}+&;o=
zU+%wBYtR~EmudxCLF}K}25m#^w_1nR5&NUoqxHnD)rPd8*idai8;H5H3ElgG0Z!?s
z;!|p~v{|u|+70bStfJPYwZ*2@j%Y_>MYVtyh&@!hH}|C4D(hCI&dvBuXV2t}zv%Tb
e>yD-FyIPS}6#JoeLAwz9sn)0U#hU)T1OEYQX1@Ud

literal 0
HcmV?d00001

-- 
1.8.1.4

