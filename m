Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab3ILM2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:28:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56834 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3ILM2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:28:43 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v2 0/2] regulator: da9210: support Device Tree initialisation
Date: Thu, 12 Sep 2013 14:28:33 +0200
Message-Id: <1378988915-10539-1-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
X-Provags-ID: V02:K0:u/tTNaJknHCd677tF3JXPppLT15866a2shyJ8lipmHe
 H35+IfRTKy1354xqysXGvFSslIo+0BEjZTaYlLlUlZ6pPISToD
 NsWeTOuK63ZN8qY7Wl72qJLl9GZY/+QoAAdtR5io3S4poDwprF
 zYwOuvFH2dZNyRX/sVUuLkHG/YDlksAZe+yQitI8EmHzz0lvEt
 K6tcYFxo77DIQjt7tVVkm+D4TSPt2fVS+zjSc3zzoj0oqoGRVD
 05OipN88oMPLNghNKH22TdglEoJA4m46yPvFIkeJcFE55jalsI
 +2/vR9tHJRAjeYU8wbti53sHnB0zsAOnK+cM2D/Y6BS+c60a8p
 1tfZHavWtWHG16uYyk/n5QFEzh+2IbB7hnYztnT16dMRb3hTEU
 VAWgCAyvwbOSQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch just adds a vendor prefix for Dialog Semiconductor PLC, the
second one actually implements DT support in da9210.

Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>

v2: add DT documentation

Guennadi Liakhovetski (2):
  DT: add a vendor prefix for Dialog Semiconductor
  regulator: da9210: add Device Tree support

 .../devicetree/bindings/regulator/da9210.txt       |   21 ++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/regulator/da9210-regulator.c               |    9 +++++--
 3 files changed, 28 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/da9210.txt

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
