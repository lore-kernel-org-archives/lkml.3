Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237Ab3GSNDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:03:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59347 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759903Ab3GSNDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:03:50 -0400
From: Illia Smyrnov <illia.smyrnov@globallogic.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH 0/2] Input: omap-keypad: Cleanup - remove hardcoded values and IRQ enabling/disabling
Date: Fri, 19 Jul 2013 16:03:45 +0300
Message-ID: <1374239027-3927-1-git-send-email-illia.smyrnov@globallogic.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Illia Smyrnov <illia.smyrnov@ti.com>

Replace unclear hardcoded values with bit field and remove 
unnecessary IRQ enabling/disabling.

Based on top of v3.10-rc1.

Tested on OMAP4 SDP.

Illia Smyrnov (2):
  Input: omap-keypad: Cleanup - use bitfiled instead of hardcoded
    values
  Input: omap-keypad: Cleanup - remove unnecessary IRQ
    enabling/disabling

 drivers/input/keyboard/omap4-keypad.c |   40 ++++++++++++--------------------
 1 files changed, 15 insertions(+), 25 deletions(-)

