Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab3IMA4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:56:13 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:57875 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab3IMA4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:56:07 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hyun Kwon <hyunk@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] SI570 clock driver
Date: Thu, 12 Sep 2013 17:55:36 -0700
Message-Id: <1379033737-30015-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another try to submit a driver for SI570 programmable clock
generators. The heart of the driver is Günther's code from
https://github.com/groeck/si570, which is wrapped in the common
clock infrastructure.

Due to the lack of platforms with oder devices only the SI570 is
actually tested.

	Thanks,
	Sören

Soren Brinkmann (1):
  clk: si570: Add a driver for SI570 oscillators

 .../devicetree/bindings/clock/silabs,si570.txt     |  31 ++
 drivers/clk/Kconfig                                |  10 +
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-si570.c                            | 546 +++++++++++++++++++++
 4 files changed, 588 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/silabs,si570.txt
 create mode 100644 drivers/clk/clk-si570.c

-- 
1.8.4

