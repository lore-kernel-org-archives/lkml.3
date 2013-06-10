Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab3FJJOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:14:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4036 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab3FJJOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:14:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 10 Jun 2013 02:13:56 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 0/2] Bugfixes for Tegra memory controllers.
Date: Mon, 10 Jun 2013 12:13:42 +0300
Message-ID: <1370855624-30564-1-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's two simple bugfixes for the Tegra memory controllers.

Tuomas Tynkkynen (2):
  memory: tegra20-mc: Fix hang in IRQ handler.
  memory: tegra30-mc: Fix IRQ handler.

 drivers/memory/tegra20-mc.c | 5 ++++-
 drivers/memory/tegra30-mc.c | 9 ++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

-- 
1.8.1.5

