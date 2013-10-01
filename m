Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab3JAJb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 05:31:56 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34529 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3JAJby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:31:54 -0400
From: =?UTF-8?q?Mathieu=20Rh=C3=A9aume?= <mathieu@codingrhemes.com>
To: mathieu@codingrhemes.com
Cc: lenb@kernel.org, rjw@sisk.pl, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] acpi: processor_driver: fixed a brace coding style issue
Date: Tue,  1 Oct 2013 05:29:39 -0400
Message-Id: <1380619779-16386-1-git-send-email-mathieu@codingrhemes.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue. (Brace not on the good line)

Signed-off-by: Mathieu Rhéaume <mathieu@codingrhemes.com>
---
 drivers/acpi/processor_driver.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index e534ba6..40fc773 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -153,8 +153,7 @@ static int acpi_cpu_soft_notify(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __refdata acpi_cpu_notifier =
-{
+static struct notifier_block __refdata acpi_cpu_notifier = {
 	    .notifier_call = acpi_cpu_soft_notify,
 };
 
-- 
1.8.3.1

