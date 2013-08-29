Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3H2RNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:13:42 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52752 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab3H2RNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:13:40 -0400
Message-ID: <521F8157.20203@arm.com>
Date: Thu, 29 Aug 2013 18:13:59 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Sudeep.KarkadaNagesha@arm.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ARM/ARM64 architected timer updates for v3.12
X-OriginalArrivalTime: 29 Aug 2013 17:13:38.0208 (UTC) FILETIME=[1A0B8A00:01CEA4DB]
X-MC-Unique: 113082918133804701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

These are the ARM/ARM64 arch timer updates for v3.12.
I have re-based the changes on tip/timers/core as there are conflicts
with memory mapped arch_timers support queued recently.
Since this series adds CPU PM notifiers for arch_timers, it is required
to enable ARM bL cpuidle drivers(already queued for v3.12)

Regards,
Sudeep

The following changes since commit cfb6d656d569510ac9239583ce09e4c92ad54719:

  Merge branch 'timers/clockevents-next' of
git://git.linaro.org/people/dlezcano/clockevents into timers/core
(2013-08-21 14:59:23 +0200)

are available in the git repository at:


  git://linux-arm.org/linux-skn.git timer_evtstrm

for you to fetch changes up to f74f198e540c160b1db9470b679dbeb72339829b:

  drivers: clocksource: add CPU PM notifier for ARM architected timer
(2013-08-29 17:43:08 +0100)

----------------------------------------------------------------
Sudeep KarkadaNagesha (4):
   ARM/ARM64: arch_timer: add macros for bits in control register
   ARM: arch_timer: add support to configure and enable event stream
   ARM64: arch_timer: add support to configure and enable event stream
   drivers: clocksource: add CPU PM notifier for ARM architected timer

Will Deacon (1):
   drivers: clocksource: add support for ARM architected timer event stream
q
 arch/arm/include/asm/arch_timer.h    | 36 ++++++++++++++++---
 arch/arm/include/uapi/asm/hwcap.h    |  1 +
 arch/arm/kernel/setup.c              |  1 +
 arch/arm64/include/asm/arch_timer.h  | 42 ++++++++++++++++++---
 arch/arm64/include/asm/hwcap.h       | 11 +++---
 arch/arm64/include/uapi/asm/hwcap.h  |  1 +
 arch/arm64/kernel/setup.c            | 11 ++++++
 drivers/clocksource/Kconfig          | 15 ++++++++
 drivers/clocksource/arm_arch_timer.c | 49 +++++++++++++++++++++++++
 include/clocksource/arm_arch_timer.h | 10 +++++
 10 files changed, 161 insertions(+), 16 deletions(-)



