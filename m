Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaLVKgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 05:36:54 -0500
Received: from regular2.263xmail.com ([211.157.152.3]:59803 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbaLVKgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 05:36:52 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: wulf@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 104.167.231.20
X-LOGIN-NAME: wulf@rock-chips.com
X-UNIQUE-TAG: <1135e787ce8219d315ca88ad0f35b868>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Wu Liang feng <wulf@rock-chips.com>
To: heiko@sntech.de
Cc: huangtao@rock-chips.com, kever.yang@rock-chips.com,
        eddie.cai@rock-chips.com, roy.li@rock-chips.com, zyw@rock-chips.com,
        jwerner@google.com, dianders@google.com, posciak@google.com,
        tfiga@google.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Wu Liang feng <wulf@rock-chips.com>
Subject: [PATCH 0/2] Support EHCI reset after resume quirk
Date: Mon, 22 Dec 2014 18:36:26 +0800
Message-Id: <1419244588-5227-1-git-send-email-wulf@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for EHCI controller to do reset
after resume if necessory. 

Wu Liang feng (2):
  dt-bindings: usb-ehci: Add an optional property
    "needs-reset-on-resume"
  USB: ehci-platform: Support ehci reset after resume quirk

tested on rk3288 chromebook board

 Documentation/devicetree/bindings/usb/usb-ehci.txt | 1 +
 drivers/usb/host/ehci-hcd.c                        | 6 +++---
 drivers/usb/host/ehci-platform.c                   | 6 +++++-
 drivers/usb/host/ehci.h                            | 2 +-
 include/linux/usb/ehci_pdriver.h                   | 3 +++
 5 files changed, 13 insertions(+), 5 deletions(-)

-- 
1.8.3.2


