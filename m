Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaHYGaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 02:30:17 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10636 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbaHYGaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 02:30:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 24 Aug 2014 23:20:18 -0700
From: Wei Ni <wni@nvidia.com>
To: <edubezval@gmail.com>, <khali@linux-fr.org>, <linux@roeck-us.net>,
        <swarren@wwwdotorg.org>
CC: <lm-sensors@lm-sensors.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v3 0/4] expose lm90 to thermal fw
Date: Mon, 25 Aug 2014 14:29:44 +0800
Message-ID: <1408948188-4181-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose lm90 to thermal framework via DT nodes.

This series is v3, previous version patches are:
[v2]: https://lkml.org/lkml/2014/3/4/194

Changes from v2:
add more description in documentation, per Stephen's comment.

Changes from v1:
1. remove the unnecessary log messages, per Guenter's request.
2. add thermal zones node for nct1008 on dalmore.

Wei Ni (1):
  thermal: add more description for thermal-zones

lightning314 (3):
  hwmon: (lm90) split set&show temp as common codes
  hwmon: lm90: expose to thermal fw via DT nodes
  ARM: tegra: dalmore: add thermal zones for nct1008

 .../devicetree/bindings/thermal/thermal.txt        |  10 +-
 arch/arm/boot/dts/tegra114-dalmore.dts             |  20 +-
 drivers/hwmon/lm90.c                               | 222 ++++++++++++++++-----
 3 files changed, 192 insertions(+), 60 deletions(-)

-- 
1.8.1.5

