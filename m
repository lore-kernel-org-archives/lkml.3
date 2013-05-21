Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab3EUIwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:52:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47174 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3EUIwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:52:36 -0400
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-input@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <grant.likely@secretlab.ca>, <dmitry.torokhov@gmail.com>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <manishv.b@ti.com>
Subject: [PATCH V3 0/2] Add DT support for tps6507x touchscreen
Date: Tue, 21 May 2013 14:24:16 +0530
Message-ID: <1369126458-24872-1-git-send-email-manishv.b@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch set adds DT support for tps6507x based touchscreen.
Also, add DT data for tps6507x touchscreen in da850-evm by
providing touchscreen node inside tps6507x mfd device.

This patch series applies on top of linux-next tree and depends on [1].

[1]tps6507x-ts: update to devm_* API
   https://patchwork.kernel.org/patch/2324441/

Tested on da850-evm board.

Changes since V2:
 - Updated tps6507x documentation.
 - Removed unnecessary code.

Changes since V1:
 - Updated tps6507x documentation.
 - Updated commit message.
 - return proper error value in absence platform and DT data
   for touchscreen.

Vishwanathrao Badarkhe, Manish (2):
  tps6507x-ts: Add DT support
  ARM: davinci: da850: add tps6507x touchscreen DT data

 Documentation/devicetree/bindings/mfd/tps6507x.txt |   28 ++++++-
 arch/arm/boot/dts/da850-evm.dts                    |    9 ++
 drivers/input/touchscreen/tps6507x-ts.c            |   98 ++++++++++++++------
 3 files changed, 104 insertions(+), 31 deletions(-)

-- 
1.7.4.1

