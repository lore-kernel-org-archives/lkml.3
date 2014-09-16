Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaIPIIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:08:54 -0400
Received: from s250.sam-solutions.net ([217.21.49.219]:46730 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaIPIIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:08:48 -0400
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <perex@perex.cz>, <tiwai@suse.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <=devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: [PATCH v3 0/4] Add Phytec pbab01 audio support
Date: Tue, 16 Sep 2014 11:08:19 +0300
Message-ID: <1410854903-26419-1-git-send-email-d.lavnikevich@sam-solutions.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410537872-17274-1-git-send-email-d.lavnikevich@sam-solutions.com>
References: <1410537872-17274-1-git-send-email-d.lavnikevich@sam-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New phyFLEX board audio patchset version.

Defines from dt-bindings/sound/fsl-imx-audmux.h are now used in audmux
configuration instead of hardcoded register values.

Also patchset is now based on branch for-next from
git://git.kernel.org/pub/scm/linux/kernel/git/shawnguo/linux.git which
means:

- removed #sound-dai-cells in ssi2 node since it was already moved to
  imx6qdl.dtsi;
- patch for imx_v6_v7_defconfig now enables only
  CONFIG_SND_SOC_TLV320AIC3X since CONFIG_SND_SIMPLE_CARD also was
  already enabled.

