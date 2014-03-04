Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbaCDLa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:30:59 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3766 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbaCDLa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:30:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 04 Mar 2014 03:26:45 -0800
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>, <swarren@wwwdotorg.org>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v2 0/3] expose lm90 to thermal fw
Date: Tue, 4 Mar 2014 19:31:01 +0800
Message-ID: <1393932664-13319-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose lm90 to thermal framework via DT nodes.

Changes from v1:
1. remove the unnecessary log messages, per Guenter's request.
2. add thermal zones node for nct1008 on dalmore.

Wei Ni (3):
  hwmon: (lm90) split set&show temp as common codes
  hwmon: lm90: expose to thermal fw via DT nodes
  ARM: tegra: dalmore: add thermal zones for nct1008

 arch/arm/boot/dts/tegra114-dalmore.dts |   20 ++-
 drivers/hwmon/lm90.c                   |  222 ++++++++++++++++++++++++--------
 2 files changed, 186 insertions(+), 56 deletions(-)

-- 
1.7.9.5

