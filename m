Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353AbaLEDWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:22:54 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:49973 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaLEDWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:22:53 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH v3 0/3] toshiba_acpi: Hotkeys and event handling changes
Date: Thu,  4 Dec 2014 20:22:44 -0700
Message-Id: <1417749767-3898-1-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches change the current code to accomodate the handling
of more events, since so far, it only handles hotkey events (0x80),
move the hotkey enabling code to a sub function to avoid duplication,
and add event 0x92 which indicates a change in the keyboard backlight
mode.

Changes since V3:
- Removed a left over variable from the split in patch 02 and
  moved it to patch 03 (where it belongs)
- A bit more verbose description on patch 03

Azael Avalos (3):
  toshiba_acpi: Move hotkey enabling code to own function
  toshiba_acpi: Change notify funtion to handle more events
  toshiba_acpi: Add keyboard backlight mode change event

 drivers/platform/x86/toshiba_acpi.c | 139 ++++++++++++++++++++++--------------
 1 file changed, 86 insertions(+), 53 deletions(-)

-- 
2.1.2

