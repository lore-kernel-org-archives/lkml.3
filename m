Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaIERO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:14:26 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:58660 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaIEROY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:14:24 -0400
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>,
        Darren Hart <dvhart@infradead.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH 0/5] toshiba_acpi: Various changes plus fixes
Date: Fri,  5 Sep 2014 11:14:02 -0600
Message-Id: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up for review.

This series of patches introduce support for the new
keyboard backlight type found on recent Toshiba laptops,
removes the position sysfs entry and instead creates an
input polled device (joystick), and a few fixes and
additions to the keymap list.

Azael Avalos (5):
  toshiba_acpi: Additional hotkey scancodes
  toshiba_acpi: Fix illumination not available on certain models
  toshiba_acpi: Add accelerometer input polled device
  toshiba_acpi: Support new keyboard backlight type
  toshiba_acpi: Change touchpad store to check for invalid values

 drivers/platform/x86/toshiba_acpi.c | 277 ++++++++++++++++++++++++++----------
 1 file changed, 199 insertions(+), 78 deletions(-)

-- 
2.0.0

