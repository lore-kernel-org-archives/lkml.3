Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3HFAV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 20:21:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57239 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806Ab3HFAVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 20:21:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 0/5] ACPI: acpi_bind_one()/acpi_unbind_one() cleanups
Date: Tue, 06 Aug 2013 02:22:53 +0200
Message-ID: <3015032.qfOqgEVZKP@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The following 5 patches clean up a little mess in acpi_bind_one() and
acpi_unbind_one().  They are on top of current linux-next plus the patch
at https://patchwork.kernel.org/patch/2839101/ .

[1/5] Move duplicated code from acpi_bind_one()/acpi_unbind_one() to a separate
      function.
[2/5] Create symlinks in acpi_bind_one() under physical_node_lock.
[3/5] Clean up inconsistent use of whitespace in acpi_bind_one()/acpi_unbind_one().
[4/5] Use list_for_each_entry() to walk the list in acpi_unbind_one().
[5/5] Clean up the error code path in acpi_unbind_one().

Thanks,
Rafael

