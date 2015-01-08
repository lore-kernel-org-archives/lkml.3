Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbbAHISJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:18:09 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:40259 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbbAHISH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:18:07 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LFBDEV <linux-fbdev@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/2] fbdev: ssd1307fb: fixes
Date: Thu,  8 Jan 2015 08:17:57 +0000
Message-Id: <1420705079-3741-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes trivial issues in ssd1307fb driver.

Lad, Prabhakar (2):
  fbdev: ssd1307fb: set default height if not found in DT node
  fbdev: ssd1307fb: check return value while setting offset

 drivers/video/fbdev/ssd1307fb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
1.9.1

