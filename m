Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab3FRRHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:07:07 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45956 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860Ab3FRRHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:07:05 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com, linux@arm.linux.org.uk,
        catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com,
        marc.zyngier@arm.com, tglx@linutronix.de,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH 0/4] ARM/ARM64 architected timer updates
Date: Tue, 18 Jun 2013 18:06:59 +0100
Message-Id: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
X-OriginalArrivalTime: 18 Jun 2013 17:07:00.0622 (UTC) FILETIME=[3F52BAE0:01CE6C46]
X-MC-Unique: 113061818070200501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r5IH8Qn9002379

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Hi,

This patch series adds support to configure the rate and enable the event
stream for architected timer. Since the timer control register is reset to
zero on warm boot, CPU PM notifier is added to re-initialse it.

Regards,
Sudeep

Sudeep KarkadaNagesha (3):
  ARM: arch_timer: add macros for bits in control register
  ARM/ARM64: arch_timer: remove __cpuinit attribute for
    arch_counter_set_user_access
  drivers: clocksource: add CPU PM notifier for ARM architected timer

Will Deacon (1):
  drivers: clocksource: configure event stream for ARM arch timer

 arch/arm/include/asm/arch_timer.h    | 10 ++++++--
 arch/arm64/include/asm/arch_timer.h  | 12 +++++++---
 drivers/clocksource/arm_arch_timer.c | 46 +++++++++++++++++++++++++++++++++++-
 include/clocksource/arm_arch_timer.h | 10 ++++++++
 4 files changed, 72 insertions(+), 6 deletions(-)

-- 
1.8.1.2


