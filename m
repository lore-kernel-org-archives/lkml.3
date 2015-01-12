Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbbALSbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:31:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58446 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbbALSbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:31:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jason Baron <jbaron@akamai.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 200/216] powercap / RAPL: add support for CPU model 0x3f
Date: Mon, 12 Jan 2015 18:29:38 +0000
Message-Id: <1421087394-2712-88-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Baron <jbaron@akamai.com>

commit 64c7569c065564a066bb44161f904b4afc9f3e3a upstream.

I've confirmed that monitoring the package power usage as well as setting power
limits appear to be working as expected. Supports the package and dram domains.

Tested aginst cpu:

Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz

Signed-off-by: Jason Baron <jbaron@akamai.com>
Acked-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/powercap/intel_rapl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
index b1cda6ffdbcc..a362dcc20ec0 100644
--- a/drivers/powercap/intel_rapl.c
+++ b/drivers/powercap/intel_rapl.c
@@ -953,6 +953,7 @@ static const struct x86_cpu_id rapl_ids[] = {
 	{ X86_VENDOR_INTEL, 6, 0x3a},/* Ivy Bridge */
 	{ X86_VENDOR_INTEL, 6, 0x3c},/* Haswell */
 	{ X86_VENDOR_INTEL, 6, 0x3d},/* Broadwell */
+	{ X86_VENDOR_INTEL, 6, 0x3f},/* Haswell */
 	{ X86_VENDOR_INTEL, 6, 0x45},/* Haswell ULT */
 	/* TODO: Add more CPU IDs after testing */
 	{}
-- 
2.1.4

