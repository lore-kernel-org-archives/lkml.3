Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaLCFgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 00:36:39 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:44628 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaLCFgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 00:36:38 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH 0/2] toshiba_acpi: Hotkeys and event handling changes
Date: Tue,  2 Dec 2014 22:36:30 -0700
Message-Id: <1417584992-2524-1-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches change the current code to accomodate
the handling of more events, since so far, it only
handles hotkey events (0x80), as well as move some
hotkey enabling code to a sub function to avoid
duplication.

Azael Avalos (2):
  toshiba_acpi: Move hotkey enabling code to own function
  toshiba_acpi: Change notify funtion to handle more events

 drivers/platform/x86/toshiba_acpi.c | 139 ++++++++++++++++++++++--------------
 1 file changed, 86 insertions(+), 53 deletions(-)

-- 
2.1.2

