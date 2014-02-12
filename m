Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaBLSBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:01:31 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39282 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaBLSBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:01:30 -0500
From: dirk.brandewie@gmail.com
To: linux-pm@vger.kernel.org, rjw@rjwysocki.net
Cc: linux-kernel@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 0/5] intel_pstate updates for v3.14-rcX
Date: Wed, 12 Feb 2014 10:01:02 -0800
Message-Id: <1392228067-14817-1-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

Based on v3.14-rc2

Patch 1 removes energy reporting the patch from Maurizio Lambardi 
 intel_pstate: fix race condition in intel_pstate_init() can be dropped.

Patch 2-3 cleanups

Patch 4-5 Baytrail bug fixes

Dirk Brandewie (5):
  intel_pstate: Remove energy reporting from pstate_sample tracepoint
  intel_pstate: remove unneeded sample buffers
  intel_pstate: fix pid_reset to use fixed point values
  intel_pstate: Use LFM bus ratio as min ratio/P state
  intel_pstate: Add support for Baytrail turbo P states

 drivers/cpufreq/intel_pstate.c | 53 +++++++++++++++++++++---------------------
 include/trace/events/power.h   |  7 +-----
 2 files changed, 27 insertions(+), 33 deletions(-)

-- 
1.8.3.1

