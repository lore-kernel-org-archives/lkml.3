Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbbANVl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:41:57 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:34596 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbbANVk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:40:27 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH 0/4] toshiba_acpi: Add support for USB Sleep functions
Date: Wed, 14 Jan 2015 14:40:17 -0700
Message-Id: <1421271621-8330-1-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches add support to several USB Sleep functions
found on newer Toshiba laptops, allowing to use th USB ports while
the laptop is asleep or turned off.

Azael Avalos (4):
  toshiba_acpi: Add support for USB Sleep and Charge function
  toshiba_acpi: Add support for USB Sleep functions under battery
  toshiba_acpi: Add support for USB Rapid Charge
  toshiba_acpi: Add support for USB Sleep and Music

 drivers/platform/x86/toshiba_acpi.c | 449 ++++++++++++++++++++++++++++++++++++
 1 file changed, 449 insertions(+)

-- 
2.2.1

