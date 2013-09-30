Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab3I3UMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:12:32 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:62125 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab3I3UMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:12:30 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 0/3] calxedaxgmac: fixes for xgmac_set_rx_mode
Date: Mon, 30 Sep 2013 15:12:14 -0500
Message-Id: <1380571937-23439-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This is a couple of fixes related to xgmac_set_rx_mode. The changes are
necessary for "bridge fdb add" to work correctly.

Rob

Rob Herring (3):
  net: calxedaxgmac: fix clearing of old filter addresses
  net: calxedaxgmac: add uc and mc filter addresses in promiscuous mode
  net: calxedaxgmac: determine number of address filters at runtime

 drivers/net/ethernet/calxeda/xgmac.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

-- 
1.8.1.2

