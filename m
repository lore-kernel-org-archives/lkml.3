Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206Ab3CWM7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 08:59:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40022 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab3CWM7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 08:59:12 -0400
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-doc@vger.kernel.org>
CC: <dmitry.torokhov@gmail.com>, <rob@landley.net>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <manishv.b@ti.com>
Subject: [PATCH 0/2] Add dT support for tps6507x touchscreen.
Date: Sat, 23 Mar 2013 18:29:29 +0530
Message-ID: <1364043571-9210-1-git-send-email-manishv.b@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch set adds DT support for tps6507x based touchscreen
Also, add DT data for tps6507x touchscreen in da850-evm by 
providing touchscreen node inside tps6507x mfd device.

This patch series applies on top of v3.9-rc2 of linus tree and
depends on [1].  

[1]davinci: Add device tree data for tps6507x
   http://www.spinics.net/lists/linux-doc/msg09473.html
 
Tested on da850-evm board.

Vishwanathrao Badarkhe, Manish (2):
  tps6507x-ts: Add DT support
  ARM: davinci: da850: add tps6507x touchscreen DT data

 Documentation/devicetree/bindings/mfd/tps6507x.txt |   22 ++++
 arch/arm/boot/dts/da850-evm.dts                    |    9 ++
 drivers/input/touchscreen/tps6507x-ts.c            |  104 ++++++++++++++------
 3 files changed, 105 insertions(+), 30 deletions(-)

-- 
1.7.4.1

