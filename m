Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3EVRr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 13:47:58 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:42289 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab3EVRr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 13:47:57 -0400
From: "Felipe F. Tonello" <eu@felipetonello.com>
To: linux-mmc@vger.kernel.org
Cc: ben-linux@fluff.org, cjb@laptop.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org,
        "Felipe F. Tonello" <eu@felipetonello.com>
Subject: [PATCH 0/2] Added set_power handler to mmc sdhci host
Date: Wed, 22 May 2013 10:47:10 -0700
Message-Id: <1369244832-23868-1-git-send-email-eu@felipetonello.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Felipe F. Tonello" <eu@felipetonello.com>

This set_power handler is useful for modules that need to be turned off when
the mmc host turns off.

Felipe F. Tonello (2):
  mmc: sdhci: Added set_power sdhci_ops handler.
  mmc: sdhci-s3c: Added set_power handler to platdata

 drivers/mmc/host/sdhci-s3c.c                | 8 ++++++++
 drivers/mmc/host/sdhci.c                    | 8 ++++++++
 drivers/mmc/host/sdhci.h                    | 1 +
 include/linux/platform_data/mmc-sdhci-s3c.h | 1 +
 4 files changed, 18 insertions(+)

-- 
1.8.1.4

