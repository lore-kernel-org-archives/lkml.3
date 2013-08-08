Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966104Ab3HHS3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 14:29:43 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:47163 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051Ab3HHS3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 14:29:41 -0400
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: tony.luck@intel.com, bp@alien8.de, bhelgaas@google.com,
        rostedt@goodmis.org, rjw@sisk.pl, lance.ortiz@hp.com,
        m.chehab@samsung.com
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: [PATCH 0/3] Add trace event for ghes memory error
Date: Thu,  8 Aug 2013 23:57:48 +0530
Message-Id: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080818-9264-0000-0000-0000044A723B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a new trace event for memory errors reported via APEI
generic hardware error source.

- Naveen

Naveen N. Rao (3):
  mce: acpi/apei: trace: Include PCIe AER trace event conditionally
  mce: acpi/apei: trace: Add trace event for ghes memory error
  mce: acpi/apei: trace: Enable ghes memory error trace event

 drivers/acpi/apei/cper.c               |  21 +++--
 drivers/pci/pcie/aer/aerdrv_errprint.c |   1 +
 include/trace/events/ras.h             | 159 ++++++++++++++++++++++++++++++++-
 3 files changed, 175 insertions(+), 6 deletions(-)

-- 
1.8.3.4

