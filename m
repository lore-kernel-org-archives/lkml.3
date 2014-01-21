Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaAUJ5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:57:33 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10742 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbaAUJ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:57:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 21 Jan 2014 01:56:53 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Airlie <airlied@linux.ie>
CC: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/2] Support for LG-LH500WX1-SD03 and LG-LD070WX3-SL01 panels
Date: Tue, 21 Jan 2014 18:57:08 +0900
Message-ID: <1390298230-13190-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for the panels used on the NVIDIA SHIELD and
Tegra Note 7 using the simple-panel driver, as both platforms are to be proposed
for inclusion into mainline soon.

Alexandre Courbot (2):
  drm/panel: add support for LG LH500WX1-SD03 panel
  drm/panel: add support for LG LD070WX3-SL01 panel

 .../devicetree/bindings/panel/lg,ld070wx3-sl01.txt |  7 +++
 .../devicetree/bindings/panel/lg,lh500wx1-sd03.txt |  7 +++
 drivers/gpu/drm/panel/panel-simple.c               | 56 ++++++++++++++++++++++
 3 files changed, 70 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/panel/lg,ld070wx3-sl01.txt
 create mode 100644 Documentation/devicetree/bindings/panel/lg,lh500wx1-sd03.txt

-- 
1.8.5.3

