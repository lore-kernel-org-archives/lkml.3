Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbaCLNql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:46:41 -0400
Received: from gloria.sntech.de ([95.129.55.99]:44222 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbaCLNqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:46:39 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 0/3] gpio-charger: add devicetree support
Date: Wed, 12 Mar 2014 14:45:42 +0100
Message-ID: <12569216.pGctOhkhxz@phil>
User-Agent: KMail/4.11.5 (Linux/3.12-1-amd64; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds devicetree support to the gpio-charger and fixes a small
issue with the return value of gpio_get_value.

Heiko Stuebner (3):
  dt-bindings: document gpio-charger bindings
  power: gpio-charger: add device tree support
  power: gpio-charger: do not use gpio value directly

 .../bindings/power_supply/gpio-charger.txt         | 23 ++++++++
 drivers/power/gpio-charger.c                       | 68 ++++++++++++++++++++--
 2 files changed, 87 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/gpio-charger.txt

-- 
1.8.5.3


