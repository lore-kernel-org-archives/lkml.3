Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbaEQOoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 10:44:24 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:50729 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116AbaEQOoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 10:44:21 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-hotplug@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 0/2] dell-wmi: Add support for Fn key combinations
Date: Sat, 17 May 2014 16:43:35 +0200
Message-Id: <1400337817-14473-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <201405171639.45722@pali>
References: <201405171639.45722@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add support for Fn key combinations to dell-wmi driver.
I tested this patch series on laptop Dell Latitude E6440.

Here is Bios DMI table which contains scancode to keycode mapping:

Handle 0xB200, DMI type 178, 80 bytes
OEM-specific Type
        Header and Data:
                B2 50 00 B2 07 01 0C 00 08 01 0A 00 09 01 0B 00
                0A 01 12 00 3B 00 20 00 42 00 18 00 48 00 14 00
                50 00 13 00 10 00 FF 00 11 00 FF 00 12 00 FF 00
                13 00 FF 00 14 00 FF 00 1E 00 FF 00 1F 00 FF 00
                20 00 FF 00 21 00 FF 00 22 00 FF 00 4D 00 16 00
        Strings:

As you can see, more different keys are mapped to one keycode 0xFF.

Pali Rohár (2):
  Input: Add keycodes for some missing Fn key combinations
  dell-wmi: Add support for Fn key combinations

 drivers/platform/x86/dell-wmi.c |   27 ++++++++++++++++++++++++++-
 include/uapi/linux/input.h      |    6 ++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

-- 
1.7.9.5

