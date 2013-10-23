Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3JWJcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:32:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54397 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab3JWJcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:32:08 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Benoit Cousson <bcousson@baylibre.com>, Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] ARM: dts: omap5-uevm: Audio related fixes
Date: Wed, 23 Oct 2013 12:32:18 +0300
Message-ID: <1382520740-11197-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When the omap5-evm.dts file has been renamed to omap5-uevm.dts and the sEVM
support got deprecated in favor of uEVM (or Panda5) the content was not
validated.
The reset GPIO is different on uEVM compared to sEVM and uEVM does not have
support for dmic.

Regards,
Peter
---
Peter Ujfalusi (2):
  ARM: dts: omap5-uevm: Correct twl6040 reset GPIO pinmux
  ARM: dts: omap5-uevm: Remove pinmux for dmic pins

 arch/arm/boot/dts/omap5-uevm.dts | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

-- 
1.8.4

