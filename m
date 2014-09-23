Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaIWL7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:59:43 -0400
Received: from gloria.sntech.de ([95.129.55.99]:53219 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbaIWL7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:59:41 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: sre@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, dianders@chromium.org, heiko@sntech.de
Subject: [PATCH v3 0/3] gpio-charger: add devicetree support
Date: Tue, 23 Sep 2014 13:59:02 +0200
Message-Id: <1411473545-3290-1-git-send-email-heiko@sntech.de>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds devicetree support to the gpio-charger and fixes a small
issue with the return value of gpio_get_value.

changes since v2:
- fix (hopefully all) issues pointed out by Doug Anderson
- add missing of_node assignment to charger
changes since v1:
- adapt binding example to show how the charger fits into the
  power-supplies structure


Heiko Stuebner (3):
  dt-bindings: document gpio-charger bindings
  power: gpio-charger: add device tree support
  power: gpio-charger: do not use gpio value directly

 .../bindings/power_supply/gpio-charger.txt         | 27 ++++++++
 drivers/power/gpio-charger.c                       | 74 +++++++++++++++++++++-
 2 files changed, 98 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/gpio-charger.txt

-- 
2.1.0

