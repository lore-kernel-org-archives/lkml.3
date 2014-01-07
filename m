Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaAGWwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 17:52:20 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:45731 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754136AbaAGWvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 17:51:13 -0500
From: Feng Kan <fkan@apm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V2 6/6] acpi: platform: add ACPI code for X-Gene reboot platform driver.
Date: Tue,  7 Jan 2014 14:50:41 -0800
Message-Id: <1389135041-16062-7-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1389135041-16062-1-git-send-email-fkan@apm.com>
References: <1389135041-16062-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ACPI code for X-Gene reboot platform driver.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 drivers/acpi/acpi_platform.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index dbfe49e..9fe1d4f 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -37,6 +37,9 @@ static const struct acpi_device_id acpi_platform_device_ids[] = {
 	{ "INT33C8" },
 	{ "80860F28" },
 
+	/* APM X-Gene */
+	{ "APMC0D08" },
+
 	{ }
 };
 
-- 
1.7.6.1

