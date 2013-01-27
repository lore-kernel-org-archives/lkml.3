Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab3A0I7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 03:59:15 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17973 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab3A0I7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 03:59:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 27 Jan 2013 00:57:02 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH RESEND 0/4] mfd/regulator: tps65090: add DT support and suspend/resume cleanups
Date: Sun, 27 Jan 2013 14:27:11 +0530
Message-ID: <1359277035-16854-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series add DT support on TPS65090 device.

Also remove the suspend/resume implementation as it duplicates with
irq_suspend/irq_resume().

Resending this patch series incase of it is missed.

Laxman Dewangan (4):
  mfd: tps65090: add DT support for tps65090
  regulator: tps65090: add DT support
  mfd: tps65090: Pass irq domain when adding mfd sub devices
  mfd: tps65090: remove suspend/resume callbacks

 .../devicetree/bindings/regulator/tps65090.txt     |  121 ++++++++++++++++++++
 drivers/mfd/tps65090.c                             |   77 ++++++++----
 drivers/regulator/tps65090-regulator.c             |   96 +++++++++++++++-
 include/linux/mfd/tps65090.h                       |    1 +
 4 files changed, 266 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/tps65090.txt

