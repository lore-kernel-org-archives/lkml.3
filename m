Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab3IFOZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:25:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:60534 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab3IFOZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:25:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,854,1371106800"; 
   d="scan'208";a="291643516"
From: Lan Tianyu <tianyu.lan@intel.com>
To: tianyu.lan@intel.com, lenb@kernel.org, rjw@sisk.pl, yinghai@kernel.org,
        bhelgaas@google.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/4] ACPI/PCI: Parse PCI root bridge's ACPI resource via ACPI resource functions
Date: Fri,  6 Sep 2013 10:24:42 -0400
Message-Id: <1378477486-8758-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is to add memory prefecth flag setting and address
translation support in the ACPI resource function. Convert PCI
root bridge's ACPI resource to generic resource via ACPI resource
functions.

PATCH 3 is to add new function acpi_dev_resource_address_space_with_addr()
to meet requirement that ACPI address space info is still needed after
being converted to generic resource.

[RFC PATCH 1/4] ACPI/Resource: Add memory prefetch check support
[RFC PATCH 2/4] ACPI/Resource: Add address translation support
[RFC PATCH 3/4] ACPI: Add new acpi_dev_resource_address_space_with_addr()
[RFC PATCH 4/4] X86/PCI/ACPI: Rework setup_resource() via functions ACPI
