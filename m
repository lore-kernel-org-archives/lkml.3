Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3FYP4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:56:32 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45203 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3FYPzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:55:14 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 0/3] net: davinci: driver cleanup
Date: Tue, 25 Jun 2013 21:24:50 +0530
Message-Id: <1372175693-20318-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch series cleans up the davinci driver.

This patch series applies on 3.10.rc7 and is boot tested
on OMAP-L138 EVM with DT and non DT cases.

Changes for v2:
1: Dropped patches which removed include files.

Lad, Prabhakar (3):
  net: davinci: emac: Convert to devm_* api
  net: davinci_emac: simplify the OF parser code
  net: davinci_mdio: gaurd the DT code with IS_ENABLED(CONFIG_OF)

 drivers/net/ethernet/ti/davinci_emac.c |  116 +++++++++-----------------------
 drivers/net/ethernet/ti/davinci_mdio.c |    5 +-
 2 files changed, 36 insertions(+), 85 deletions(-)

-- 
1.7.9.5

