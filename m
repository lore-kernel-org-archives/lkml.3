Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab3BOXgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 18:36:33 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13333 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3BOXgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 18:36:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 15 Feb 2013 15:35:51 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [RFC 0/3] Add DT Binding for Power-Supply supplied-nodes property
Date: Fri, 15 Feb 2013 18:36:53 -0500
Message-ID: <1360971416-30717-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is an attempt to define a common way for devicetree
initialized power_supplies to define their list of supplicants
in a common manner.

Instead of relying on custom properties which contain is list of
strings, use the much more direct method of phandles to reference
the supplicants and define a common function which can retrieve them
automatically.

Rhyland Klein (3):
  power_supply: Define Binding for supplied-nodes
  power: power_supply: Add core support for supplied_nodes
  power: power_supply: add support for getting supplied-nodes from dt

 .../bindings/power_supply/power_supply.txt         |   17 ++++
 drivers/power/power_supply_core.c                  |   82 +++++++++++++++++++-
 include/linux/power_supply.h                       |   10 +++
 3 files changed, 107 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/power_supply.txt

-- 
1.7.9.5

