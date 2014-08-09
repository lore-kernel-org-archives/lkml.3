Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbaHIFin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 01:38:43 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:38496 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaHIFim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 01:38:42 -0400
Date: Sat, 9 Aug 2014 14:37:11 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] staging: dgap: remove redundant declarations.
Message-ID: <20140809053711.GA14635@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are already defined in dgap.h.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 55c06c9..b1253c0 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -158,12 +158,6 @@ static void dgap_err(char *s);
 /*
  * Function prototypes from dgap_sysfs.h
  */
-struct board_t;
-struct channel_t;
-struct un_t;
-struct pci_driver;
-struct class_device;
-
 static void dgap_create_ports_sysfiles(struct board_t *bd);
 static void dgap_remove_ports_sysfiles(struct board_t *bd);
 
-- 
1.7.1

