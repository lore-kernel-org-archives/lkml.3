Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbaBDNbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 08:31:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:49202 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbaBDNa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:30:59 -0500
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>, <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/2] usb: musb: host: fixes for 3.14-rc
Date: Tue, 4 Feb 2014 15:25:47 +0200
Message-ID: <1391520349-26192-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Patch 1 fixes SuperSpeed hub enumeration on beaglebone.
Patch 2 fixes remote-wakeup resume on beaglebone.

Felipe has Acked the 1st patch but still needs to Ack the 2nd one.

Patches are based on 3.14-rc1

cheers,
-roger

Ajay Kumar Gupta (1):
  usb: musb: host: Fix SuperSpeed hub enumeration

Roger Quadros (1):
  usb: musb: core: Fix remote-wakeup resume

 drivers/usb/musb/musb_core.c | 10 +++++++++-
 drivers/usb/musb/musb_host.c |  3 +++
 2 files changed, 12 insertions(+), 1 deletion(-)

-- 
1.8.3.2

