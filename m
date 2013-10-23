Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab3JWQ26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 12:28:58 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63168 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3JWQ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 12:28:56 -0400
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: devicetree-discuss@lists.ozlabs.org, devicetree@vger.kernel.org,
        linux-input@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Cc: grant.likely@secretlab.ca, dmitry.torokhov@gmail.com,
        rob.herring@calxeda.com, rob@landley.net, badarkhe.manish@gmail.com
Subject: [PATCH V4 0/2] Add DT support for tps6507x touchscreen 
Date: Wed, 23 Oct 2013 21:58:51 +0530
Message-Id: <1382545733-8865-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch set adds DT support for tps6507x based touchscreen.
Also, add DT data for tps6507x touchscreen in da850-evm by
providing touchscreen node inside tps6507x mfd device.

This patch series applies on top of linux-next tree and depends on [1].

[1]tps6507x-ts: update to devm_* API
   https://patchwork.kernel.org/patch/2324441/

Changes since V3:
 - Rebased on top of Dmitry's changes
 - Removed error handling for optional DT properties

Changes since V2:
 - Updated tps6507x documentation.
 - Removed unnecessary code.

Changes since V1:
 - Updated tps6507x documentation.
 - Updated commit message.
 - return proper error value in absence platform and DT data
   for touchscreen.

Manish Badarkhe (2):
  tps6507x-ts: Add DT support
  ARM: davinci: da850: add tps6507x touchscreen DT data

 Documentation/devicetree/bindings/mfd/tps6507x.txt |   24 +++++-
 arch/arm/boot/dts/da850-evm.dts                    |    8 ++
 drivers/input/touchscreen/tps6507x-ts.c            |   79 +++++++++++++-------
 3 files changed, 82 insertions(+), 29 deletions(-)

-- 
1.7.10.4

