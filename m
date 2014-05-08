Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaEHHkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:40:55 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:50503 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaEHHku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:40:50 -0400
From: Johan Hovold <jhovold@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Mugunthan V N <mugunthanvnm@ti.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 0/5] net: cpsw and mdio-gpio fixes for v3.15-final
Date: Thu,  8 May 2014 09:37:14 +0200
Message-Id: <1399534639-4947-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches against v3.15-rc4 fix a few issues in the cpsw and
mdio-gpio drivers.

Johan


Johan Hovold (5):
  net: mdio-gpio: fix device-tree binding documentation
  net: mdio-gpio: warn about missing bus alias id
  Revert "net: eth: cpsw: Correctly attach to GPIO bitbang MDIO driver"
  net: cpsw: fix null dereference at probe
  net: cpsw: add missing of_node_put

 Documentation/devicetree/bindings/net/mdio-gpio.txt |  2 +-
 drivers/net/ethernet/ti/cpsw.c                      | 17 ++++++-----------
 drivers/net/phy/mdio-gpio.c                         |  4 ++++
 3 files changed, 11 insertions(+), 12 deletions(-)

-- 
1.8.3.2

