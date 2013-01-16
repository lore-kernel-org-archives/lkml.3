Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab3APMqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:46:36 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52080 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab3APMpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:45:16 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
CC: Archit Taneja <archit@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] OMAPDSS: Panel NEC: backlight handling changes
Date: Wed, 16 Jan 2013 13:45:06 +0100
Message-ID: <1358340309-8774-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

While working with Zoom2 which is using the NEC panel I noticed few issues with
the panel driver.
The first patch fixes one irritating warning print every time I boot the board.
With the third patch we can cleanly move to bl-pwm driver to handle the
backlight on Zoom2. In this case we should not register another backlight device
in the NEC panel driver.

Regards,
Peter
---
Peter Ujfalusi (3):
  OMAPDSS: Panel NEC: Set backlight type to remove boot time warning
  OMAPDSS: Panel NEC: Get rid of nec_80848_data structure
  OMAPDSS: Panel NEC: Only register backlight when we have valid
    callback

 .../omap2/displays/panel-nec-nl8048hl11-01b.c      | 81 ++++++++++------------
 1 file changed, 35 insertions(+), 46 deletions(-)

-- 
1.8.1

