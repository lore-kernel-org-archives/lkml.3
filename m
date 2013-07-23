Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649Ab3GWQKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:10:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54069 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933221Ab3GWQKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:10:04 -0400
From: Illia Smyrnov <illia.smyrnov@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <balbi@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH v2 0/3] Input: omap-keypad: Convert to threaded IRQ and cleanup
Date: Tue, 23 Jul 2013 19:09:55 +0300
Message-ID: <1374595798-15492-1-git-send-email-illia.smyrnov@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace unclear hardcoded values with bit field, convert to threaded IRQ and
clear pending interrupts when open the keypad.

Based on top of v3.11-rc2.

Tested on OMAP4 SDP.

Illia Smyrnov (3):
  Input: omap-keypad: Cleanup - use bitfiled instead of hardcoded
    values
  Input: omap-keypad: Convert to threaded IRQ
  Input: omap-keypad: Clear pending interrupts on open

 drivers/input/keyboard/omap4-keypad.c |   59 +++++++++++++++++++--------------
 1 files changed, 34 insertions(+), 25 deletions(-)

