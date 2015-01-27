Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbbA0IOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:14:07 -0500
Received: from sci-ig2.spreadtrum.com ([222.66.158.135]:19109 "EHLO
	SHSQR01.spreadtrum.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756896AbbA0IOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:14:03 -0500
From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
To: <mark.rutland@arm.com>, <arnd@arndb.de>, <catalin.marinas@arm.com>,
        <will.deacon@arm.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>
CC: <Joel.Schopp@amd.com>, <Thomas.Lendacky@amd.com>,
        <Suravee.Suthikulpanit@amd.com>, <broonie@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <geng.ren@spreadtrum.com>,
        <zhizhou.zhang@spreadtrum.com>, <zhang.lyra@gmail.com>,
        <wei.qiao@spreadtrum.com>, <orsonzhai@gmail.com>
Subject: [PATCH v7 0/2] Add Spreadtrum Sharkl64 Platform support
Date: Tue, 27 Jan 2015 16:12:45 +0800
Message-ID: <1422346367-10628-1-git-send-email-chunyan.zhang@spreadtrum.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <sc9836-dt-v7>
References: <sc9836-dt-v7>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.0.67.142]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 SHMBX02.spreadtrum.com (10.0.1.204)
X-MAIL: SHSQR01.spreadtrum.com t0R8DNJh072988
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set split the last version, and addressed the review comments from
last version on serial driver code.

Changes from v6:
	- Setted stdout-path with "serial1:115200n8"

Changes from v5:
	- Added maintenance interrupt for gic
	- Removed reg property from 'soc' and 'apb' nodes

Zhizhou Zhang (2):
  arm64: dts: Add support for Spreadtrum SC9836 SoC in dts and Makefile
  arm64: Add support for Spreadtrum's Sharkl64 Platform in Kconfig and
    defconfig

 arch/arm64/Kconfig                            |    5 ++
 arch/arm64/boot/dts/Makefile                  |    1 +
 arch/arm64/boot/dts/sprd/Makefile             |    5 ++
 arch/arm64/boot/dts/sprd/sc9836-openphone.dts |   49 ++++++++++++++++
 arch/arm64/boot/dts/sprd/sc9836.dtsi          |   74 +++++++++++++++++++++++++
 arch/arm64/boot/dts/sprd/sharkl64.dtsi        |   65 ++++++++++++++++++++++
 arch/arm64/configs/defconfig                  |    1 +
 7 files changed, 200 insertions(+)
 create mode 100644 arch/arm64/boot/dts/sprd/Makefile
 create mode 100644 arch/arm64/boot/dts/sprd/sc9836-openphone.dts
 create mode 100644 arch/arm64/boot/dts/sprd/sc9836.dtsi
 create mode 100644 arch/arm64/boot/dts/sprd/sharkl64.dtsi

-- 
1.7.9.5

