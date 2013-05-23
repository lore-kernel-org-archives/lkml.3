Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab3EWKT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:19:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41836 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757799Ab3EWKT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:19:57 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/1] USB: ehci-omap: Fixes for 3.10
Date: Thu, 23 May 2013 13:19:46 +0300
Message-ID: <1369304387-29610-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

There is one patch for 3.10 that fixes an issue with dma_mask pointer
when ehci-omap is used as a module and kernel is booted using
device tree. More details in the patch.

Roger Quadros (1):
  USB: ehci-omap: Reset dma_mask pointer on probe

 drivers/usb/host/ehci-omap.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

cheers,
-roger
-- 
1.7.4.1

