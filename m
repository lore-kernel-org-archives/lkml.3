Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaKFRk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:40:59 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58955 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaKFRk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:40:57 -0500
From: dirk.brandewie@gmail.com
X-Google-Original-From: dirk.j.brandewie@intel.com
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: rjw@rjwysocki.net, dirk.brandweie@gmail.com, robert.a.kasten@intel.com,
        charles.d.prestopine@intel.com, x86@kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 0/2] intel_pstate: Add support for hardware managed P states (HWP)
Date: Thu,  6 Nov 2014 09:40:45 -0800
Message-Id: <1415295647-4063-1-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

This patch set adds support for HWP. When HWP is enabled the CPU will
do P state autonomously and intel_pstate simply provides an interface
to forward user preferences to the CPU while maintaining the
interfaces required by the cpufreq core. 

Dirk Brandewie (2):
  x86: Add support for Intel HWP feature detection.
  intel_pstate: Add support for HWP

 Documentation/cpu-freq/intel-pstate.txt |  37 ++++++++----
 Documentation/kernel-parameters.txt     |   3 +
 arch/x86/include/asm/cpufeature.h       |   5 ++
 arch/x86/include/uapi/asm/msr-index.h   |  41 +++++++++++++
 arch/x86/kernel/cpu/scattered.c         |   5 ++
 drivers/cpufreq/intel_pstate.c          | 102 +++++++++++++++++++++++++++++++-
 6 files changed, 178 insertions(+), 15 deletions(-)

-- 
1.9.3

