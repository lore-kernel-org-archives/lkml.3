Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab3LEXB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:01:56 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:24744 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3LEXBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:01:55 -0500
X-IronPort-AV: E=Sophos;i="4.93,836,1378882800"; 
   d="scan'208";a="389913"
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        ARM Linux List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Subject: [PATCH 0/2] Update bcm_defconfig
Date: Thu, 5 Dec 2013 15:00:36 -0800
Message-ID: <1386284438-11099-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series includes two minor updates to the bcm_defconfig that
removes an option that wasn't being used and eliminates a line that
is now unnecessary due to a change in the defaults for that option.

Tim Kryger (2):
  ARM: bcm_defconfig: CONFIG_OABI_COMPAT default off
  ARM: bcm_defconfig: Unset CONFIG_CRYPTO_ANSI_CPRNG

 arch/arm/configs/bcm_defconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.8.0.1

