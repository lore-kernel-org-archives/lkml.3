Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3KGSBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 13:01:11 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:46645 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab3KGSBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 13:01:09 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v3 0/2] clk/zynq: fclk-enable feature
Date: Thu,  7 Nov 2013 10:00:42 -0800
Message-Id: <1383847244-2079-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is v3. The only change is a doc fix. Regarding the vendor prefix for
properties, I counted one vote for it and one against + the already existing
bindings that don't have a vendor prefix and my personal preference; and nobody
else seems to have a strong opinion on this. Therefore I left it out.

	Thanks,
	Sören

Soren Brinkmann (2):
  clk/zynq/clkc: Add 'fclk-enable' feature
  arm: dt: zynq: Add fclk-enable property to clkc node

 Documentation/devicetree/bindings/clock/zynq-7000.txt |  4 ++++
 arch/arm/boot/dts/zynq-7000.dtsi                      |  1 +
 drivers/clk/zynq/clkc.c                               | 18 +++++++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

-- 
1.8.4.2

