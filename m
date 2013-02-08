Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806Ab3BHKqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 05:46:49 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:35885 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964774Ab3BHKqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 05:46:48 -0500
From: Vijay Kumar Mishra <vijay.kumar@st.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <spear-devel@codex.cro.st.com>, <viresh.kumar@linaro.org>,
        Vijay Kumar Mishra <vijay.kumar@st.com>
Subject: [PATCH 0/3] Patch set fixing SPEAr13xx boot issues on V3.8-rc6
Date: Fri, 8 Feb 2013 16:16:28 +0530
Message-ID: <cover.1360317993.git.vijay.kumar@st.com>
X-Mailer: git-send-email 1.6.0.2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set contains following patches:

1. Enables correct kernel/user memory split required for SPEAr13xx.
2. Fix to correct SPEAr1310 device tree.
3. Fix to add ARM ABI support.

This patch set is tested on kernel V3.8-rc6.  

Vijay Kumar Mishra (3):
  SPEAr13xx_defconfig: Enable Memory split 2G/2G needed
  ARM:dts:SPEAr1310:Correct the clcd pin group name
  SPEAr13xx_defconfig: Enable compilation using the latest ARM ABI

 arch/arm/boot/dts/spear1310-evb.dts  |    2 +-
 arch/arm/configs/spear13xx_defconfig |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

-- 
1.7.9.5

