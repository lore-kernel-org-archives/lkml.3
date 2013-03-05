Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3CEIVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:21:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:37765 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3CEIVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:21:05 -0500
X-IronPort-AV: E=Sophos;i="4.84,785,1355068800"; 
   d="scan'208";a="6815899"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: lenb@kernel.org, rjw@sisk.pl, robert.moore@intel.com, lv.zheng@intel.com,
        ming.m.lin@intel.com, mpm@selenic.com, herbert@gondor.hengli.com.au,
        rob@landley.net
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, trival@kernel.org
Subject: [PATCH 0/6] Fix some coding style and comment problems.
Date: Tue, 5 Mar 2013 16:23:22 +0800
Message-Id: <1362471808-9437-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 16:20:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 16:20:02,
	Serialize complete at 2013/03/05 16:20:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some coding style and comment problems I saw when I was reading the code.

Tang Chen (6):
  In acpi_memory_device_notify()
  In acpi_get_table_with_size()
  In acpi_tb_table_override()
  In acpi_tb_install_table()
  In acpi_initialize_tables()
  In Documentation/hw_random.txt

 Documentation/hw_random.txt    |    2 +-
 drivers/acpi/acpi_memhotplug.c |    2 +-
 drivers/acpi/acpica/tbinstal.c |    2 +-
 drivers/acpi/acpica/tbutils.c  |    2 +-
 drivers/acpi/acpica/tbxface.c  |    6 +++---
 5 files changed, 7 insertions(+), 7 deletions(-)

