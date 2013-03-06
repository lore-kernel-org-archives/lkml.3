Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab3CFI1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 03:27:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27096 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab3CFI1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 03:27:47 -0500
X-IronPort-AV: E=Sophos;i="4.84,793,1355068800"; 
   d="scan'208";a="6823120"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: lenb@kernel.org, rjw@sisk.pl, robert.moore@intel.com, lv.zheng@intel.com,
        ming.m.lin@intel.com, mpm@selenic.com, herbert@gondor.hengli.com.au,
        rob@landley.net
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [RESEND PATCH 0/6] Fix some coding style and comment problems.
Date: Wed, 6 Mar 2013 16:30:05 +0800
Message-Id: <1362558611-32255-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 16:26:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 16:26:42,
	Serialize complete at 2013/03/06 16:26:42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some coding style and comment problems I saw when I was reading the code.

Tang Chen (6):
  acpi: Remove the leading space of "unlock" label in
    acpi_memory_device_notify().
  acpi: Add missing parameter comment for acpi_get_table_with_size().
  acpi: Remove the leading spaces of "finish_override" label in
    acpi_tb_table_override().
  acpi: Remove the leading spaces of "unmap_and_exit" label in
    acpi_tb_install_table().
  acpi: Add the missing parameter comment for acpi_initialize_tables().
  doc: Fix a wrong comment in Documentation/hw_random.txt

 Documentation/hw_random.txt    |    2 +-
 drivers/acpi/acpi_memhotplug.c |    2 +-
 drivers/acpi/acpica/tbinstal.c |    2 +-
 drivers/acpi/acpica/tbutils.c  |    2 +-
 drivers/acpi/acpica/tbxface.c  |    6 +++---
 5 files changed, 7 insertions(+), 7 deletions(-)

