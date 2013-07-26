Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab3GZRJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:09:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36126 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759115Ab3GZRJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:09:09 -0400
From: Illia Smyrnov <illia.smyrnov@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v2 0/3] Input: omap-keypad: Wakeup capability and w/a for i689 errata.
Date: Fri, 26 Jul 2013 20:09:03 +0300
Message-ID: <1374858546-25034-1-git-send-email-illia.smyrnov@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds wake up capability for the keypad and
workaround for i689 errata.

Based on top of v3.11-rc2

Depends on:

Input: omap-keypad: Convert to threaded IRQ
https://patchwork.kernel.org/patch/2832920/

Input: omap-keypad: Cleanup - use bitfiled instead of hardcoded values
https://patchwork.kernel.org/patch/2832913/

Axel Haslam (2):
  Input: omap-keypad: errata i689: Correct debounce time
  Input: omap-keypad: Set irq to level instead of edge

Illia Smyrnov (1):
  Input: omap-keypad: Enable wakeup capability for keypad.

 drivers/input/keyboard/omap4-keypad.c |   55 +++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 3 deletions(-)

-- 
1.7.9.5

