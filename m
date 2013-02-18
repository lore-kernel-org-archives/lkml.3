Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab3BRFMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:12:16 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46956 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab3BRFMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:12:13 -0500
From: J Keerthy <j-keerthy@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b-cousson@ti.com>,
        <sameo@linux.intel.com>, <broonie@opensource.wolfsonmicro.com>
CC: <j-keerthy@ti.com>, <gg@slimlogic.co.uk>
Subject: [PATCH 0/4] mfd: Palmas: Correct the DT Node properties naming convention and add documentation.
Date: Mon, 18 Feb 2013 10:40:15 +0530
Message-ID: <1361164215-3093-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series corrects the DT node properties naming convention and adds
Documentation for the Palmas PMIC.

Graeme Gregory (1):
  documentation: add palmas dts definition

J Keerthy (3):
  mfd: palmas: Change the DT node property names to follow the
    convention
  regulator: palmas: Removing duplicated code
  regulator: palmas: Change the DT node property names to follow the
    convention

 Documentation/devicetree/bindings/mfd/palmas.txt |   67 ++++++++++++++++++++++
 drivers/mfd/palmas.c                             |    6 +-
 drivers/regulator/palmas-regulator.c             |   13 +---
 3 files changed, 74 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/palmas.txt

-- 
1.7.5.4

