Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab3K2NCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 08:02:14 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59981 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683Ab3K2NCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 08:02:11 -0500
From: Roger Quadros <rogerq@ti.com>
To: <lee.jones@linaro.org>, <sameo@linux.intel.com>
CC: <tomi.valkeinen@ti.com>, <balbi@ti.com>, <sr@denx.de>,
        <ljkenny.mailinglists@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/1] mfd: omap-usb-host: Bug fix for 3.13 rc
Date: Fri, 29 Nov 2013 15:01:57 +0200
Message-ID: <1385730118-26402-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fixes USB device detection issues on OMAP4 Panda with
latest u-boot release v2013.10.

Please queue it for 3.13-rc cycle. Thanks.

cheers,
-roger

Roger Quadros (1):
  mfd: omap-usb-host: Fix USB device detection problems on OMAP4 Panda

 drivers/mfd/omap-usb-host.c | 115 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 109 insertions(+), 6 deletions(-)

-- 
1.8.3.2

