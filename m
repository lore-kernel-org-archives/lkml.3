Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab3AVCHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 21:07:40 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48964 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab3AVCHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 21:07:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lv Zheng <lv.zheng@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 0/4] ACPI / PM: Initial power state checking and power state setting changes
Date: Tue, 22 Jan 2013 03:05:41 +0100
Message-ID: <1792467.qHBR6KraFh@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The following patches make the determination of the initial device power state
more robust and change the way ACPI device power states are changed to be more
in line with the spec.

[1/4] Make the determination of initial device power states more robust.
[2/4] Reduce duplication of code between ACPI device PM functions.
[3/4] Make the changing of device power states follow the spec literally.
[4/4] Sanitize checks in acpi_power_on_resources().

The patches are on top of linux-pm.git/linux-next.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
