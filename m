Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbbAZNPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:15:46 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:5574 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbbAZNPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:15:44 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <tiwai@suse.de>, <perex@perex.cz>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <Zubair.Kakakhel@imgtec.com>,
        <lars@metafoo.de>
Subject: [PATCH_V2 0/4] sound:soc: jz4740: DT, dynamic sampling, enable clocks
Date: Mon, 26 Jan 2015 13:15:34 +0000
Message-ID: <1422278138-51097-1-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are a few simple patches for the jz4740.

First adds dynamic sampling support to jz4740-i2s.
Then two to add a simple binding and DT support.
Then a patch to set the clock rate for i2s.

These are in preparation for jz4780 and ci20 later on.

Patches are based on 3.19-rc6. Quite disjoint and stay within jz4740 
so should apply easily on other trees.

If you would like to have them rebased to a different tree, please tell.

Thank-you

V2 changes: 
Removed a redundant #define
Added #ifdef CONFIG_OF
Added dma in binding document
Removed a redundant call to clk_prepare_enable

Zubair Lutfullah Kakakhel (4):
  sound: soc: jz4740: Add dynamic sampling rate support to jz4740-i2s
  dt: sound: jz4740: Add binding documentation for jz4740-i2s
  sound: soc: jz4740: Add DT support to jz4740-i2s driver
  sound: jz4740: set i2s clk rate to 12MHz

 .../bindings/sound/ingenic,jz4740-i2s.txt          | 21 +++++++++++++++++++++
 sound/soc/jz4740/jz4740-i2s.c                      | 22 +++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/sound/ingenic,jz4740-i2s.txt

-- 
1.9.1

