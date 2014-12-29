Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaL2Jmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 04:42:44 -0500
Received: from regular1.263xmail.com ([211.150.99.132]:46716 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaL2Jmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 04:42:42 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: roger.chen@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: roger.chen@rock-chips.com
X-UNIQUE-TAG: <eb4c6f9bb740e2b2fd7a043e51f5d821>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Roger Chen <roger.chen@rock-chips.com>
To: heiko@sntech.de
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        kever.yang@rock-chips.com, eddie.cai@rock-chips.com,
        roger.chen@rock-chips.com
Subject: [PATCH v3 0/6] support GMAC driver for RK3288
Date: Mon, 29 Dec 2014 17:42:32 +0800
Message-Id: <1419846152-14531-1-git-send-email-roger.chen@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roger Chen (6):
  patch1: add driver for Rockchip RK3288 SoCs integrated GMAC
  patch2: define clock ID used for GMAC
  patch3: modify CRU config for Rockchip RK3288 SoCs integrated GMAC
  patch4: dts: rockchip: add gmac info for rk3288
  patch5: dts: rockchip: enable gmac on RK3288 evb board
  patch6: add document for Rockchip RK3288 GMAC

Tested on rk3288 evb board:
Execute the following command to enable ethernet,
set local IP and ping a remote host.

busybox ifconfig eth0 up
busybox ifconfig eth0 192.168.1.111
ping 192.168.1.1

-- 
1.7.9.5


