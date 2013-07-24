Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab3GXPzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:55:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51697 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab3GXPzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:55:02 -0400
From: Illia Smyrnov <illia.smyrnov@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH v3 0/3] Input: omap-keypad: Convert to threaded IRQ and cleanup
Date: Wed, 24 Jul 2013 18:54:50 +0300
Message-ID: <1374681293-5320-1-git-send-email-illia.smyrnov@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace unclear hardcoded values with bit field, convert to threaded IRQ and
clear interrupts when open the keypad.

Based on top of v3.11-rc2.

Tested on OMAP4 SDP.

Illia Smyrnov (3):
  Input: omap-keypad: Cleanup - use bitfiled instead of hardcoded
    values
  Input: omap-keypad: Convert to threaded IRQ
  Input: omap-keypad: Clear interrupts on open

 drivers/input/keyboard/omap4-keypad.c |   57 +++++++++++++++++++--------------
 1 files changed, 33 insertions(+), 24 deletions(-)

