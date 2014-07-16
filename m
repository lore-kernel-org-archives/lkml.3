Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079AbaGPNJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:09:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55993 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933369AbaGPNJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:09:08 -0400
From: George Cherian <george.cherian@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [RESEND PATCH v3 0/4] Cleanup for dwc3-omap
Date: Wed, 16 Jul 2014 18:37:04 +0530
Message-ID: <1405516028-26500-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series does some refactoring on dwc3_probe()

Patch 1 - Now that we use driver compatible for revision check, remove the unnecessary logic.
Patch 2-4 - reduce the size of dwc3_probe()

George Cherian (4):
  usb: dwc3: dwc3-omap: Remove x_major calculation from revision
    register
  usb: dwc3: dwc3-omap: Add dwc3_omap_map_offset() function
  usb: dwc3: dwc3-omap: Add dwc3_omap_set_utmi_mode() function
  usb: dwc3: dwc3-omap: Add dwc3_omap_extcon_register function

 drivers/usb/dwc3/dwc3-omap.c | 170 +++++++++++++++++++++----------------------
 1 file changed, 84 insertions(+), 86 deletions(-)

-- 
1.8.3.1

