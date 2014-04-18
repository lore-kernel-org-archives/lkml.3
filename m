Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaDRTEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 15:04:37 -0400
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:59601 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752189AbaDRTE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 15:04:29 -0400
X-Greylist: delayed 3376 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Apr 2014 15:04:29 EDT
From: Suman Tripathi <stripathi@apm.com>
To: kishon@ti.com, tj@kernel.org
Cc: olof@lixom.net, arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ddutile@redhat.com, jcm@redhat.com, patches@apm.com,
        Suman Tripathi <stripathi@apm.com>
Subject: [PATCH 0/2] PHY: Add SATA Gen1/Gen2 support to the APM X-Gene SoC 15Gbps PHY driver
Date: Fri, 18 Apr 2014 23:33:15 +0530
Message-Id: <1397844197-13356-1-git-send-email-stripathi@apm.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary code to support SATA Gen1/Gen2 for the APM X-Gene
SoC 15Gbps Multi-purpose PHY driver.

Suman Tripathi (2):
  PHY: Add function set_rate to generic PHY framework
  PHY: Add Gen1/Gen2 support for the APM SoC X-Gene SATA PHY driver

 drivers/phy/phy-core.c  | 29 ++++++++++++++++++++++
 drivers/phy/phy-xgene.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/phy/phy.h |  8 +++++++
 3 files changed, 101 insertions(+)

--
1.8.2.1

