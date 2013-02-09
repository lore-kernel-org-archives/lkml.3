Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947515Ab3BIBIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:08:31 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:57092 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758593Ab3BIBI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:08:29 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: idle patches queued for Linux-3.9
Date: Fri,  8 Feb 2013 20:08:04 -0500
Message-Id: <1360372100-28482-1-git-send-email-lenb@kernel.org>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is my idle patch queue for Linux-3.9.

As noted below, some patches are unchanged since last seen
on the list, some are re-freshed, and some are new.

Please let me know if you see troubles with any of them.

thanks,
Len Brown, Intel Open Source Technology Center

[PATCH 01/16] intel_idle: stop using driver_data for static flags
[PATCH 02/16] Replace the flag by a simple global boolean in the
[PATCH 03/16] davinci: cpuidle - move code to prevent forward
[PATCH 04/16] davinci: cpuidle - remove the ops
[PATCH 05/16] davinci: cpuidle - remove useless initialization
[PATCH 06/16] ACPI / idle: remove unused definition
[PATCH 07/16] ACPI / idle : remove pointless headers
[PATCH 08/16] ACPI / idle: pass the cpuidle_device parameter
[PATCH 09/16] ACPI / idle: remove usage of the statedata
	Unchanged since most recent on list.

[PATCH 10/16] cpuidle: remove vestage definition of statedata
	New

[PATCH 11/16] intel_idle: support Haswell
	Refreshed

[PATCH 12/16] tools/power turbostat: support Haswell
[PATCH 13/16] tools/power turbostat: decode MSR_IA32_POWER_CTL
	Unchanged

[PATCH 14/16] intel_idle: remove use and definition of MWAIT_MAX_CSTATE
[PATCH 15/16] intel_idle: remove assumption of one C-state per MWAIT
[PATCH 16/16] intel_idle: export both C1 and C1E
	New
