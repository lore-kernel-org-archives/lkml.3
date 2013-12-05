Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3LEAXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:23:30 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:56689 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3LEAX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:23:28 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/2] Enable Calxeda cpufreq driver on arm64
Date: Wed,  4 Dec 2013 18:23:12 -0600
Message-Id: <1386202994-30784-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This series enables cpufreq subsystem and the highbank-cpufreq driver
for arm64. Nothing more really than sorting kconfig options to allow
the driver to build. There's no reason for the driver to depend on
ARCH_HIGHBANK and I'm trying to avoid adding that (or a new option)
for arm64.

Rob

Rob Herring (2):
  cpufreq: enable ARM drivers on arm64
  cpufreq: highbank: rework the kconfig dependencies for arm64

 arch/arm64/Kconfig          |  8 ++++++++
 drivers/cpufreq/Kconfig     |  2 +-
 drivers/cpufreq/Kconfig.arm | 14 ++++++--------
 3 files changed, 15 insertions(+), 9 deletions(-)

-- 
1.8.3.2

