Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab3FNMZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:25:07 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37240 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3FNMYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:24:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, Lan Tianyu <tianyu.lan@intel.com>
Subject: [PATCH 0/4] ACPI / PM: Cleanups and device power state selection rework
Date: Fri, 14 Jun 2013 14:29:57 +0200
Message-ID: <6895318.cKDBc4OdI0@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The following series of patches cleans up the ACPI device PM core code and
reworks the routine used for selecting power states to put devices into.

[1/4] Rename a function whose name is the same as the name of a data type and
      make it static.

[2/4] Replace ACPI_STATE_D3 with ACPI_STATE_D3_COLD in device_pm.c.

[3/4] Rework functions used for selecting power states to put devices into.

[4/4] Drop some unused code.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
