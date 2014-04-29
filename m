Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbaD2JeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:34:12 -0400
Received: from smtp.adetelgroup.com ([94.247.26.71]:45130 "EHLO
	hbg-pa71.hmc-pa.adm" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757131AbaD2JeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:34:10 -0400
From: Hubert Chaumette <hchaumette@adeneo-embedded.com>
To: f.fainelli@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, xobs@kosagi.com, davem@davemloft.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v3 0/2] net/phy: micrel: Add DT configuration support and
Date: Tue, 29 Apr 2014 11:33:23 +0200
Message-Id: <1398764005-23855-1-git-send-email-hchaumette@adeneo-embedded.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - Adds DT configuration support for ksz9031
 - Renames micrel-ksz9021.txt to micrel-ksz90x1.txt and adds ksz9031 binding
   documentation

Changes since v2:
 - Merged together ksz9031_load_{clk,data,ctrl}_skew_values()
 - Added field length and number of fields prameter to account for registers
  specificities
 - Added binding documentation

Changes since v1:
 - Removed ksz9021 and ksz9031 fixup deletions from arch/arm/mach-imx/mach-imx6q.c

Hubert Chaumette (2):
  Add support for ksz9031 PAD skew configuration over devicetree.
  Update Micrel KSZ90x1 binding documentation

 .../devicetree/bindings/net/micrel-ksz9021.txt     |  49 ------
 .../devicetree/bindings/net/micrel-ksz90x1.txt     |  83 ++++++++++
 drivers/net/phy/micrel.c                           | 167 ++++++---------------
 3 files changed, 127 insertions(+), 172 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/micrel-ksz9021.txt
 create mode 100644 Documentation/devicetree/bindings/net/micrel-ksz90x1.txt

-- 
1.9.2
