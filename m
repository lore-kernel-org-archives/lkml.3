Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaIDNYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:24:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52653 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaIDNYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:24:02 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <rogerq@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/2] ARM: dts: dra7-evm: fixes for mux and VTT control
Date: Thu, 4 Sep 2014 08:23:26 -0500
Message-ID: <1409837008-32144-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series was inspired in part by http://marc.info/?l=linux-omap&m=140974309205295&w=2
causing me to try and do an audit of pinctrl configurations on the platform.

Further, failures on latest board updates in the automated farm also
caused identification of a fix which was yet to be send to upstream
from product kernel. Slightly unrelated patches in this series.

So here they are..
based on v3.17-rc1:
before-dra7xx-evm:  Boot FAIL: http://paste.ubuntu.org.cn/1477597
(fails can be at different times though.. random crashes without VTT is usual)..
after-dra7xx-evm:  Boot PASS: http://paste.ubuntu.org.cn/1477596

Lokesh Vutla (1):
  ARM: dts: dra7-evm: Add vtt regulator support

Nishanth Menon (1):
  ARM: dts: dra7-evm: Fix spi1 mux documentation

 arch/arm/boot/dts/dra7-evm.dts |   39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

-- 
1.7.9.5

