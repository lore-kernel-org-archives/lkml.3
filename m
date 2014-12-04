Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaLDGmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 01:42:12 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:49579 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaLDGmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 01:42:10 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH v2 0/3] toshiba_acpi: Hotkeys and event handling changes
Date: Wed,  3 Dec 2014 23:42:02 -0700
Message-Id: <1417675325-14921-1-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches change the current code to accomodate the handling
of more events, since so far, it only handles hotkey events (0x80),
move the hotkey enabling code to a sub function to avoid duplication,
and add event 0x92 which indicates a change in the keyboard backlight
mode.

Changes since V1:
- Split patch 02 in two patches
- Some misc changes in the description of the patches (a bit wider now)

Azael Avalos (3):
  toshiba_acpi: Move hotkey enabling code to own function
  toshiba_acpi: Change notify funtion to handle more events
  toshiba_acpi: Add keyboard backlight mode change event

 drivers/platform/x86/toshiba_acpi.c | 139 ++++++++++++++++++++++--------------
 1 file changed, 86 insertions(+), 53 deletions(-)

-- 
2.1.2

