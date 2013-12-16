Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab3LPUUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:20:12 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40162 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3LPUUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:20:06 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        vincent.weaver@maine.edu, maria.n.dimakopoulou@gmail.com
Subject: [PATCH 0/2] perf/x86: various RAPL improvements
Date: Mon, 16 Dec 2013 21:20:22 +0100
Message-Id: <1387225224-27799-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short patch series provides the following improvements
to the RAPL support for perf_events:
 - Intel Haswell Celeron (model 69) support
 - support for RAPL PP1 energy counter

The PP1 counter maps to the builtin graphic card for client
processors. The new energy event is:
 - name: power/energy-gfx/
 - code: 0x4
 - unit: Joules
 - scaling factor: 2^-32 Joules.

Signed-off-by: Stephane Eranian <eranian@google.com>

Stephane Eranian (2):
  perf/x86: enable Haswell Celeron RAPL support
  perf/x86: add RAPL PP1 energy counter support

 arch/x86/kernel/cpu/perf_event_intel_rapl.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

-- 
1.7.9.5

