Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3FZSDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 14:03:22 -0400
Received: from gloria.sntech.de ([95.129.55.99]:45389 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab3FZSDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 14:03:21 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 0/3] watchdog: dw_wdt: common clock framework and devicetree support
Date: Wed, 26 Jun 2013 20:03:12 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Jamie Iles <jamie@jamieiles.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306262003.13256.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small series changes the dw_wdt driver, so that it is usable on
machines using the common clock framework (needs the clk to be prepared)
and devicetree (needs a binding).

Heiko Stuebner (3):
  watchdog: dw_wdt: convert to SIMPLE_DEV_PM_OPS
  watchdog: dw_wdt: use clk_prepare_enable and clk_disable_unprepare
  watchdog: dw_wdt: add a devicetree binding

 .../bindings/watchdog/snps-dw-apb-wdt.txt          |   18 ++++++++++++
 drivers/watchdog/dw_wdt.c                          |   31 ++++++++++++--------
 2 files changed, 36 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/watchdog/snps-dw-apb-wdt.txt

-- 
1.7.10.4

