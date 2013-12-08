Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279Ab3LHPf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 10:35:26 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46299 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3LHPfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 10:35:21 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Thierry Reding <thierry.reding@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-spi@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] spi: tegra: use u32 for 32-bit register values
Date: Sun,  8 Dec 2013 16:35:08 +0100
Message-Id: <1386516911-26388-1-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1385745164-10534-1-git-send-email-mpn@google.com>
References: <1385745164-10534-1-git-send-email-mpn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series has only been compile-tested, but it does not introduce any
behaviour changes.

Michal Nazarewicz (3):
  spi: tegra114: use u32 for 32-bit register values
  spi: tegra20-slink: use u32 for 32-bit register values
  spi: tegra20-sflash: use u32 for 32-bit register values

 drivers/spi/spi-tegra114.c       | 98 ++++++++++++++--------------------------
 drivers/spi/spi-tegra20-sflash.c | 22 ++++-----
 drivers/spi/spi-tegra20-slink.c  | 97 ++++++++++++++++-----------------------
 3 files changed, 84 insertions(+), 133 deletions(-)

-- 
1.8.4
