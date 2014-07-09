Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbaGIMYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:24:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45354 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbaGIMY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:24:27 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, <santosh.shilimkar@ti.com>,
        <netdev@vger.kernel.org>
CC: <prabhakar.csengg@gmail.com>, Sekhar Nori <nsekhar@ti.com>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 0/2] net: davinci_mdio: reuse for keystone2 arch
Date: Wed, 9 Jul 2014 16:10:49 +0300
Message-ID: <1404911451-9921-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The similar MDIO HW blocks is used by keystone 2 SoCs as
in Davinci SoCs:
- one in Gigabit Ethernet (GbE) Switch Subsystem
  See http://www.ti.com/lit/ug/sprugv9d/sprugv9d.pdf
- one in 10 Gigabit Ethernet Subsystem
  See http://www.ti.com/lit/ug/spruhj5/spruhj5.pdf

Hence, reuse Davinci MDIO driver for Keystone 2 and
enable TI networking for Keystone 2 devices.

Also, as part of this series, enable PHY's creation from DT, because
Keystone 2 supports DT boot mode only.

Grygorii Strashko (2):
  net: davinci_mdio: reuse for keystone2 arch
  net: davinci_mdio: allow to create phys from dt

 .../devicetree/bindings/net/davinci-mdio.txt       |    8 ++++----
 drivers/net/ethernet/ti/Kconfig                    |    4 ++--
 drivers/net/ethernet/ti/davinci_mdio.c             |   18 ++++++++++++++++--
 3 files changed, 22 insertions(+), 8 deletions(-)

-- 
1.7.9.5

