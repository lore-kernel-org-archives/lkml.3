Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaLAHic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 02:38:32 -0500
Received: from regular1.263xmail.com ([211.150.99.134]:57540 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaLAHib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 02:38:31 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <3f714b8c4d803c5691e043a2d665d47a>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Jianqun Xu <jay.xu@rock-chips.com>
To: heiko@sntech.de, linux@arm.linux.org.uk, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jianqun Xu <jay.xu@rock-chips.com>
Subject: [PATCH 0/2] rockchip: efuse: add driver to support rk3288 efuse
Date: Mon,  1 Dec 2014 15:34:39 +0800
Message-Id: <1417419281-9243-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In RK3288, there are two eFuse. One is organized as 32bits by 8 one-time
programmable electrical fuses with random access interface, and the other
is organized as 32bits by 32 one-time programmable electrical fuses.

Jianqun Xu (2):
  rockchip: efuse: add documentation for rk3288 efuse driver
  rockchip: efuse: add efuse driver for rk3288 efuse

 .../bindings/fuse/rockchip,rk3288-efuse.txt        |  14 ++
 arch/arm/mach-rockchip/efuse.c                     | 165 +++++++++++++++++++++
 arch/arm/mach-rockchip/efuse.h                     |  15 ++
 3 files changed, 194 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/fuse/rockchip,rk3288-efuse.txt
 create mode 100644 arch/arm/mach-rockchip/efuse.c
 create mode 100644 arch/arm/mach-rockchip/efuse.h

-- 
1.9.1


