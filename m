Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbaI3CkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 22:40:17 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41188 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaI3CkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 22:40:15 -0400
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH v2 0/3] Return codes cleanup
Date: Mon, 29 Sep 2014 20:40:06 -0600
Message-Id: <1412044809-3366-1-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up for review.

This series of patches are a cleanup to the Toshiba
configuration interface return codes (unification),
since we are now using both the HCI and the SCI, as
well as changing the returned type of the HCI/SCI
read/write functions from acpi_status to u32, since
the "status" was never checked on most of the functions.

Changes since v1:
- Be a bit more verbose on patch 1 about the Toshiba
  configuration interface
- Merged patches 3 and 4 into a same patch

Azael Avalos (3):
  toshiba_acpi: Rename hci_raw to tci_raw
  toshiba_acpi: Unify return codes prefix from HCI/SCI to TOS
  toshiba_acpi: Change HCI/SCI functions return code type

 drivers/platform/x86/toshiba_acpi.c | 369 ++++++++++++++++++------------------
 1 file changed, 183 insertions(+), 186 deletions(-)

-- 
2.0.0

