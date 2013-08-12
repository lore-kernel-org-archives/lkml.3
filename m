Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab3HLN1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:27:20 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36588 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab3HLN1R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:27:17 -0400
Message-ID: <5208E2D3.7060005@arm.com>
Date: Mon, 12 Aug 2013 14:27:47 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Sudeep.KarkadaNagesha@arm.com, Viresh Kumar <viresh.kumar@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] DT/core: cpu_ofnode updates for v3.12
X-OriginalArrivalTime: 12 Aug 2013 13:27:12.0848 (UTC) FILETIME=[A7845D00:01CE975F]
X-MC-Unique: 113081214271304301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:

  Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)

are available in the git repository at:

  git://linux-arm.org/linux-skn.git cpu_of_node

for you to fetch changes up to 9e9e26dde91f22635c87d0e45f3938b5ded96f0d:

  cpufreq: pmac32-cpufreq: remove device tree parsing for cpu nodes
(2013-08-12 10:22:29 +0100)

----------------------------------------------------------------
Sudeep KarkadaNagesha (16):
  of: add support for retrieving cpu node for a given logical cpu index
  ARM: DT/kernel: define ARM specific arch_match_cpu_phys_id
  driver/core: cpu: initialize of_node in cpu's device struture
  of/device: add helper to get cpu device node from logical cpu index
  ARM: topology: remove hwid/MPIDR dependency from cpu_capacity
  ARM: mvebu: remove device tree parsing for cpu nodes
  drivers/bus: arm-cci: avoid parsing DT for cpu device nodes
  cpufreq: imx6q-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: cpufreq-cpu0: remove device tree parsing for cpu nodes
  cpufreq: highbank-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: spear-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: kirkwood-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: arm_big_little: remove device tree parsing for cpu nodes
  cpufreq: maple-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: pmac64-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: pmac32-cpufreq: remove device tree parsing for cpu nodes

 arch/arm/kernel/devtree.c           |  5 +++++
 arch/arm/kernel/topology.c          | 61
+++++++++++++++++++------------------------------------------
 arch/arm/mach-imx/mach-imx6q.c      |  3 +--
 arch/arm/mach-mvebu/platsmp.c       | 52
++++++++++++++++++++++++----------------------------
 drivers/base/cpu.c                  |  2 ++
 drivers/bus/arm-cci.c               | 28 +++++++---------------------
 drivers/cpufreq/arm_big_little_dt.c | 40
++++++++++++++--------------------------
 drivers/cpufreq/cpufreq-cpu0.c      | 23 ++++-------------------
 drivers/cpufreq/highbank-cpufreq.c  | 18 ++++++------------
 drivers/cpufreq/imx6q-cpufreq.c     |  4 +---
 drivers/cpufreq/kirkwood-cpufreq.c  |  8 +++++---
 drivers/cpufreq/maple-cpufreq.c     | 23 +++--------------------
 drivers/cpufreq/pmac32-cpufreq.c    |  5 +++--
 drivers/cpufreq/pmac64-cpufreq.c    | 47
+++++++++++------------------------------------
 drivers/cpufreq/spear-cpufreq.c     |  4 ++--
 drivers/of/base.c                   | 73
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cpu.h                 |  1 +
 include/linux/of.h                  |  6 ++++++
 include/linux/of_device.h           | 15 +++++++++++++++
 19 files changed, 202 insertions(+), 216 deletions(-)


PS: This patch series is reviewed and acknowledged @

v1: https://lkml.org/lkml/2013/7/15/128
v2: https://lkml.org/lkml/2013/7/17/341
v3: https://lkml.org/lkml/2013/7/22/219


