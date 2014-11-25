Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaKYJID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:08:03 -0500
Received: from regular2.263xmail.com ([211.157.152.4]:48659 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaKYJIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:08:00 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: roger.chen@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: roger.chen@rock-chips.com
X-UNIQUE-TAG: <869d1af015e073f4b924c92ece2e58b0>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Roger Chen <roger.chen@rock-chips.com>
To: heiko@sntech.de
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        kever.yang@rock-chips.com, mark.yao@rock-chips.com,
        eddie.cai@rock-chips.com, roger.chen@rock-chips.com
Subject: [PATCH 0/4] support GMAC driver for RK3288
Date: Tue, 25 Nov 2014 17:07:36 +0800
Message-Id: <1416906460-26078-1-git-send-email-roger.chen@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roger Chen (4):
  patch1: add driver for Rockchip RK3288 SoCs integrated GMAC
  patch2: modify CRU config for Rockchip RK3288 SoCs integrated GMAC
  patch3: dts: add gmac info for rk3288
  patch4: dts: enable gmac on RK3288 evb board

tested on rk3288 SDK board:
busybox ifconfig eth0 up
busybox ifconfig eth0 192.168.1.111
ping 192.168.1.1

-- 
1.7.9.5


