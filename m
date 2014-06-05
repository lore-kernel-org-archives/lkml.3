Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaFENxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:53:39 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58120 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751592AbaFENxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:53:36 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: David Airlie <airlied@linux.ie>, Randy Dunlap <rdunlap@infradead.org>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 0/2] drm/panel: add support for Foxlink FL500WVR00-A0T panel
Date: Thu,  5 Jun 2014 15:53:30 +0200
Message-Id: <1401976412-27436-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series adds a new entry in the vendor-prefixes.txt file for Foxlink
Group and defines Foxlink FL500WVR00-A0T panel specifications in the simple
panel driver.

Best Regards,

Boris


Boris BREZILLON (2):
  DT: add vendor prefix for Foxlink Group
  drm/panel: add support for Foxlink FL500WVR00-A0T panel

 .../bindings/panel/foxlink,fl500wvr00-a0t.txt      |  7 ++++++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 drivers/gpu/drm/panel/panel-simple.c               | 25 ++++++++++++++++++++++
 3 files changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/panel/foxlink,fl500wvr00-a0t.txt

-- 
1.8.3.2

