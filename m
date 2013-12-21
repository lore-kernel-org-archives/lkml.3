Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3LUDsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 22:48:31 -0500
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:35409 "HELO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752515Ab3LUDsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 22:48:30 -0500
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Dec 2013 22:48:30 EST
From: Iyappan Subramanian <isubramanian@apm.com>
To: davem@davemloft.net
Cc: gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com,
        Iyappan Subramanian <isubramanian@apm.com>,
        Ravi Patel <rapatel@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Subject: [PATCH 0/5] drivers: net: Adding support for APM X-Gene SoC Ethernet base driver
Date: Fri, 20 Dec 2013 19:42:51 -0800
Message-Id: <1387597376-29303-1-git-send-email-isubramanian@apm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APM X-Gene SoC Ethernet subsystem communicates with a central Queue Manager
 (QMTM) using messages for transmit, receive and allocating data buffers.
 There are multiple ethernet interfaces in APM X-Gene SoC.

Signed-off-by: Iyappan Subramanian <isubramanian@apm.com>
Signed-off-by: Ravi Patel <rapatel@apm.com>
Signed-off-by: Keyur Chudgar <kchudgar@apm.com>
---
Iyappan Subramanian (5):
  Documentation: APM X-Gene SoC Ethernet DTS binding documentation
  arm64: dts: APM X-Gene SoC Ethernet device tree nodes
  drivers: net: APM X-Gene SoC Ethernet base driver
  drivers: net: APM X-Gene SoC Ethernet driver error handling
  drivers: net: APM X-Gene SoC Ethernet driver ethtool support

 .../devicetree/bindings/net/apm-xgene-enet.txt     |   67 +
 MAINTAINERS                                        |    7 +
 arch/arm64/boot/dts/apm-mustang.dts                |    8 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |   19 +
 drivers/net/ethernet/Kconfig                       |    1 +
 drivers/net/ethernet/Makefile                      |    1 +
 drivers/net/ethernet/apm/Kconfig                   |    1 +
 drivers/net/ethernet/apm/Makefile                  |    5 +
 drivers/net/ethernet/apm/xgene/Kconfig             |   10 +
 drivers/net/ethernet/apm/xgene/Makefile            |   12 +
 drivers/net/ethernet/apm/xgene/xgene_enet_common.c |  497 ++++++
 drivers/net/ethernet/apm/xgene/xgene_enet_common.h |  450 ++++++
 drivers/net/ethernet/apm/xgene/xgene_enet_csr.h    |  427 ++++++
 drivers/net/ethernet/apm/xgene/xgene_enet_err.c    |  715 +++++++++
 drivers/net/ethernet/apm/xgene/xgene_enet_mac.c    |  520 +++++++
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c   | 1609 ++++++++++++++++++++
 drivers/net/ethernet/apm/xgene/xgene_enet_main.h   |  177 +++
 drivers/net/ethernet/apm/xgene/xgene_enet_tools.c  |  296 ++++
 18 files changed, 4822 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/apm-xgene-enet.txt
 create mode 100644 drivers/net/ethernet/apm/Kconfig
 create mode 100644 drivers/net/ethernet/apm/Makefile
 create mode 100644 drivers/net/ethernet/apm/xgene/Kconfig
 create mode 100644 drivers/net/ethernet/apm/xgene/Makefile
 create mode 100644 drivers/net/ethernet/apm/xgene/xgene_enet_common.c
 create mode 100644 drivers/net/ethernet/apm/xgene/xgene_enet_common.h
 create mode 100644 drivers/net/ethernet/apm/xgene/xgene_enet_csr.h
 create mode 100644 drivers/net/ethernet/apm/xgene/xgene_enet_err.c
 create mode 100644 drivers/net/ethernet/apm/xgene/xgene_enet_mac.c
 create mode 100644 drivers/net/ethernet/apm/xgene/xgene_enet_main.c
 create mode 100644 drivers/net/ethernet/apm/xgene/xgene_enet_main.h
 create mode 100644 drivers/net/ethernet/apm/xgene/xgene_enet_tools.c

-- 
1.7.9.5

