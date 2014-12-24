Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaLXKWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 05:22:37 -0500
Received: from regular1.263xmail.com ([211.150.99.134]:60622 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaLXKWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 05:22:35 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: wulf@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wulf@rock-chips.com
X-UNIQUE-TAG: <f222b624bac61a06946c66da38badf9b>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Wu Liang feng <wulf@rock-chips.com>
To: heiko@sntech.de
Cc: huangtao@rock-chips.com, kever.yang@rock-chips.com,
        eddie.cai@rock-chips.com, roy.li@rock-chips.com, zyw@rock-chips.com,
        jwerner@google.com, dianders@google.com, posciak@google.com,
        tfiga@google.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Wu Liang feng <wulf@rock-chips.com>
Subject: [PATCH v2 0/2] Support EHCI reset after resume quirk
Date: Wed, 24 Dec 2014 18:22:17 +0800
Message-Id: <1419416539-3830-1-git-send-email-wulf@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH v2 1/2]: Add an optional property "needs-reset-on-resume"
		in usb-ehci dt-bingdings.
[PATCH v2 2/2]: modify ehci-platform driver to support ehci reset
		after resume quirk if necessary.

Wu Liang feng (2):
  dt-bindings: usb-ehci: Add an optional property
	       "needs-reset-on-resume"
  USB: ehci-platform: Support ehci reset after resume quirk

tested on rk3288-pinky

 Documentation/devicetree/bindings/usb/usb-ehci.txt | 1 +
 drivers/usb/host/ehci-hcd.c                        | 6 +++---
 drivers/usb/host/ehci-platform.c                   | 6 +++++-
 drivers/usb/host/ehci.h                            | 2 +-
 include/linux/usb/ehci_pdriver.h                   | 3 +++
 5 files changed, 13 insertions(+), 5 deletions(-)

-- 
1.8.3.2


