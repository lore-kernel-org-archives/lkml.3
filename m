Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaLRQvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:51:49 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:41551 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534AbaLRQvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:51:47 -0500
From: Julian Brost <linux-kernel@0x4a42.net>
To: Julian Brost <linux-kernel@0x4a42.net>,
        Fabian Hofmann <fabian.hofmann@fau.de>
Cc: linux-kernel@i4.cs.fau.de, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] perf/x86/intel/uncore: checkpatch: Replace deprecated macro.
Date: Thu, 18 Dec 2014 17:51:36 +0100
Message-Id: <1418921500-5630-2-git-send-email-linux-kernel@0x4a42.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418921500-5630-1-git-send-email-linux-kernel@0x4a42.net>
References: <1418751050-11725-1-git-send-email-linux-kernel@0x4a42.net>
 <1418921500-5630-1-git-send-email-linux-kernel@0x4a42.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DEFINE_PCI_DEVICE_TABLE macro is deprecated and was replaced with an
appropriate struct.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Julian Brost <linux-kernel@0x4a42.net>
Signed-off-by: Fabian Hofmann <fabian.hofmann@fau.de>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index f9ed429..d817c43 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -2196,7 +2196,7 @@ static struct intel_uncore_type *hswep_pci_uncores[] = {
 	NULL,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(hswep_uncore_pci_ids) = {
+static const struct pci_device_id hswep_uncore_pci_ids[] = {
 	{ /* Home Agent 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2f30),
 		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_HA, 0),
-- 
1.9.1

