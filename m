Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaDQRnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:43:09 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:44326 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaDQRnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:43:01 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Leif Lindholm <leif.lindholm@linaro.org>,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/3] of: dts: enable memory@0 quirk for PPC32 only
Date: Thu, 17 Apr 2014 18:41:58 +0100
Message-Id: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/of/fdt.c contains a workaround for a missing memory type
entry on longtrail firmware. Make that quirk PPC32 only, and while
at it - fix up the .dts files in the tree currently working only
because of that quirk.

Cc: devicetree@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>

Leif Lindholm (3):
  arm: dts: add device_type="memory" for ste-ccu8540
  mips: dts: add device_type="memory" where missing
  of: Handle memory@0 node on PPC32 only

 arch/arm/boot/dts/ste-ccu8540.dts     |    1 +
 arch/mips/lantiq/dts/easy50712.dts    |    1 +
 arch/mips/ralink/dts/mt7620a_eval.dts |    1 +
 arch/mips/ralink/dts/rt2880_eval.dts  |    1 +
 arch/mips/ralink/dts/rt3052_eval.dts  |    1 +
 arch/mips/ralink/dts/rt3883_eval.dts  |    1 +
 drivers/of/fdt.c                      |    7 ++++++-
 7 files changed, 12 insertions(+), 1 deletion(-)

-- 
1.7.10.4

