Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbaGXM7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:59:36 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49312 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758743AbaGXM7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:59:35 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 0/3] ACPICA updates for ACPI 5.1 MADT, FADT, GTDT (Just for patch review)
Date: Thu, 24 Jul 2014 20:59:14 +0800
Message-Id: <1406206757-15512-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the patch set to update ACPICA for MADT, FADT, GTDT in
ACPI 5.1. These patches are only for review purpose, ACPICA
patches will have there own special upstream process, it will be
handled by Bob and Lv.

Bob, Lv, please ignore this patch set since you are working on
them now, it just for people to undstand the later ARM64 ACPI
core patches better and for temporary test purpose. I will rebase
my patch set once new version of ACPICA is released, thanks.

Hanjun Guo (2):
  ACPI / ACPICA: Introduce ARM Boot Architecture Flags in FADT
  ACPI / ACPICA: Add GTDT support updated by ACPI 5.1

Tomasz Nowicki (1):
  ACPI / ACPICA: Add new features for MADT which introduced by ACPI 5.1

 include/acpi/actbl.h  |   12 ++++--
 include/acpi/actbl1.h |   40 +++++++++++++++++---
 include/acpi/actbl3.h |   99 ++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 129 insertions(+), 22 deletions(-)

-- 
1.7.9.5

