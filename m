Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891Ab3DPDHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 23:07:48 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:58964 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964772Ab3DPDHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 23:07:47 -0400
Date: Mon, 15 Apr 2013 20:07:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephane Eranian <eranian@google.com>
cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        jolsa@redhat.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [build error] perf/urgent broken due to
 INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG
Message-ID: <alpine.DEB.2.02.1304152002150.3952@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3de4ad210387 ("perf/x86: Fix offcore_rsp valid mask for SNB/IVB") 
in perf/urgent breaks the build:

arch/x86/kernel/cpu/perf_event_intel.c:158:2: error: implicit declaration of function 'INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG' [-Werror=implicit-function-declaration]
arch/x86/kernel/cpu/perf_event_intel.c:158:2: warning: missing braces around initializer [-Wmissing-braces]
arch/x86/kernel/cpu/perf_event_intel.c:158:2: warning: (near initialization for 'intel_snb_extra_regs[2]') [-Wmissing-braces]
arch/x86/kernel/cpu/perf_event_intel.c:158:2: error: initializer element is not constant
arch/x86/kernel/cpu/perf_event_intel.c:158:2: error: (near initialization for 'intel_snb_extra_regs[2].event')
arch/x86/kernel/cpu/perf_event_intel.c:159:2: warning: braces around scalar initializer [enabled by default]
arch/x86/kernel/cpu/perf_event_intel.c:159:2: warning: (near initialization for 'intel_snb_extra_regs[2].msr') [enabled by default]
arch/x86/kernel/cpu/perf_event_intel.c:159:2: error: field name not in record or union initializer
arch/x86/kernel/cpu/perf_event_intel.c:159:2: error: (near initialization for 'intel_snb_extra_regs[2].msr')
arch/x86/kernel/cpu/perf_event_intel.c:159:2: error: field name not in record or union initializer
arch/x86/kernel/cpu/perf_event_intel.c:159:2: error: (near initialization for 'intel_snb_extra_regs[2].msr')
arch/x86/kernel/cpu/perf_event_intel.c:159:2: warning: excess elements in scalar initializer [enabled by default]
arch/x86/kernel/cpu/perf_event_intel.c:159:2: warning: (near initialization for 'intel_snb_extra_regs[2].msr') [enabled by default]
arch/x86/kernel/cpu/perf_event_intel.c:159:2: error: field name not in record or union initializer
arch/x86/kernel/cpu/perf_event_intel.c:159:2: error: (near initialization for 'intel_snb_extra_regs[2].msr')
arch/x86/kernel/cpu/perf_event_intel.c:159:2: warning: excess elements in scalar initializer [enabled by default]
arch/x86/kernel/cpu/perf_event_intel.c:159:2: warning: (near initialization for 'intel_snb_extra_regs[2].msr') [enabled by default]
arch/x86/kernel/cpu/perf_event_intel.c:159:2: error: field name not in record or union initializer
arch/x86/kernel/cpu/perf_event_intel.c:159:2: error: (near initialization for 'intel_snb_extra_regs[2].msr')
arch/x86/kernel/cpu/perf_event_intel.c:159:2: warning: excess elements in scalar initializer [enabled by default]
arch/x86/kernel/cpu/perf_event_intel.c:159:2: warning: (near initialization for 'intel_snb_extra_regs[2].msr') [enabled by default]
arch/x86/kernel/cpu/perf_event_intel.c:159:2: error: field name not in record or union initializer
arch/x86/kernel/cpu/perf_event_intel.c:159:2: error: (near initialization for 'intel_snb_extra_regs[2].msr')
arch/x86/kernel/cpu/perf_event_intel.c:159:2: warning: excess elements in scalar initializer [enabled by default]
arch/x86/kernel/cpu/perf_event_intel.c:159:2: warning: (near initialization for 'intel_snb_extra_regs[2].msr') [enabled by default]
