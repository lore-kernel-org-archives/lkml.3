Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbbASBa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 20:30:56 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:63011 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbASBaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 20:30:55 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH v2 0/4] toshiba_acpi: Add support for USB Sleep functions
Date: Sun, 18 Jan 2015 18:30:21 -0700
Message-Id: <1421631025-27895-1-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches add support to several USB Sleep functions
found on newer Toshiba laptops, allowing to use the USB ports while
the laptop is asleep or turned off.

Changes since v1:
- Changed accepted parameters on first patch and added a short
  description of what the auto and alternate charging modes mean
- Some misc format and typo changes

Azael Avalos (4):
  toshiba_acpi: Add support for USB Sleep and Charge function
  toshiba_acpi: Add support for USB Sleep functions under battery
  toshiba_acpi: Add support for USB Rapid Charge
  toshiba_acpi: Add support for USB Sleep and Music

 drivers/platform/x86/toshiba_acpi.c | 455 ++++++++++++++++++++++++++++++++++++
 1 file changed, 455 insertions(+)

-- 
2.2.1

