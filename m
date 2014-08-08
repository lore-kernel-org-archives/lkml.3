Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbaHHCYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 22:24:38 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:38288 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaHHCYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 22:24:36 -0400
Date: Fri, 8 Aug 2014 14:24:29 +1200
From: Kurt McAlpine <kurt@linux.com>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Removed repeated word in comments in
 arch/tile/include/uapi/arch/sim_def.h
Message-ID: <20140808022429.GA5012@thepiratebay>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I have created a simple patch that removes repeated words in arch/tile/include/uapi/arch/sim_def.h

Thanks,
Kurt McAlpine

--HcAYCG3uE/tztfnV
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Removed-repeated-word-in-comments.patch"

>From 7496bc191f1ea2fde0af9d316e5330bc99e5638d Mon Sep 17 00:00:00 2001
From: Kurt McAlpine <kurtmcalpine@gmail.com>
Date: Thu, 7 Aug 2014 08:50:25 +1200
Subject: [PATCH] Removed repeated word in comments
Signed-off-by: Kurt McAlpine <kurt@linux.com>

---
 arch/tile/include/uapi/arch/sim_def.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/tile/include/uapi/arch/sim_def.h b/arch/tile/include/uapi/arch/sim_def.h
index 4b44a2b..1c06953 100644
--- a/arch/tile/include/uapi/arch/sim_def.h
+++ b/arch/tile/include/uapi/arch/sim_def.h
@@ -360,19 +360,19 @@
  * @{
  */
 
-/** Use with with SIM_PROFILER_CHIP_xxx to control the memory controllers. */
+/** Use with SIM_PROFILER_CHIP_xxx to control the memory controllers. */
 #define SIM_CHIP_MEMCTL        0x001
 
-/** Use with with SIM_PROFILER_CHIP_xxx to control the XAUI interface. */
+/** Use with SIM_PROFILER_CHIP_xxx to control the XAUI interface. */
 #define SIM_CHIP_XAUI          0x002
 
-/** Use with with SIM_PROFILER_CHIP_xxx to control the PCIe interface. */
+/** Use with SIM_PROFILER_CHIP_xxx to control the PCIe interface. */
 #define SIM_CHIP_PCIE          0x004
 
-/** Use with with SIM_PROFILER_CHIP_xxx to control the MPIPE interface. */
+/** Use with SIM_PROFILER_CHIP_xxx to control the MPIPE interface. */
 #define SIM_CHIP_MPIPE         0x008
 
-/** Use with with SIM_PROFILER_CHIP_xxx to control the TRIO interface. */
+/** Use with SIM_PROFILER_CHIP_xxx to control the TRIO interface. */
 #define SIM_CHIP_TRIO          0x010
 
 /** Reference all chip devices. */
-- 
1.9.1


--HcAYCG3uE/tztfnV--
