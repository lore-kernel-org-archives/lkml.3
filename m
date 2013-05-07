Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab3EGPUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:20:49 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39763 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab3EGPUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:20:47 -0400
From: dirk.brandewie@gmail.com
To: rjw@sisk.pl, linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: dirk <dirk.brandewie@gmail.com>
Subject: [PATCH 0/6] Intel pstate driver update
Date: Tue,  7 May 2013 08:20:24 -0700
Message-Id: <1367940030-19311-1-git-send-email-dirk.j.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: dirk <dirk.brandewie@gmail.com>

Collection of updates for cpufreq/intel_pstate.c

Patches 1-3 are bugfixes and marked for stable

Patches 4-6 are code cleanup with no functional changes.


Dirk Brandewie (6):
  cpufreq/intel_pstate: remove idle time and duration from sample and
    calculations
  cpufreq/intel_pstate: use lowest requested max performance
  cpufreq/intel_pstate: fix ffmpeg regression
  cpufreq/intel_pstate: Remove idle mode PID
  cpufreq/intel_pstate: Remove unused code
  cpufreq/intel_pstate: remove #ifdef MODULE compile fence

 drivers/cpufreq/intel_pstate.c | 122 +++++++----------------------------------
 1 file changed, 20 insertions(+), 102 deletions(-)

-- 
1.7.11.7

