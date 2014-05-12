Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaELExj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 00:53:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54001 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbaELExi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 00:53:38 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC: <mugunthanvnm@ti.com>, <davem@davemloft.net>, <balbi@ti.com>,
        <zonque@gmail.com>, <mpa@pengutronix.de>, <tklauser@distanz.ch>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v3 0/3] TI CPSW Cleanup
Date: Mon, 12 May 2014 10:21:18 +0530
Message-ID: <1399870281-27200-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series does some minimal cleanups.
	-Conversion of pr_*() to dev_*()
	-Convert kzalloc to devm_kzalloc.

No functional changes.

v1 -> v2 Address review comments.
v2 -> v3 Remove a stale commit comment.

George Cherian (3):
  driver net: cpsw: Convert pr_*() to dev_*() calls
  net: davinci_mdio: Convert pr_err() to dev_err() call
  drivers: net: davinci_cpdma: Convert kzalloc() to devm_kzalloc().

 drivers/net/ethernet/ti/cpsw.c          | 50 ++++++++++++++++-----------------
 drivers/net/ethernet/ti/davinci_cpdma.c | 35 ++++++++---------------
 drivers/net/ethernet/ti/davinci_mdio.c  |  2 +-
 3 files changed, 38 insertions(+), 49 deletions(-)

-- 
1.8.3.1

