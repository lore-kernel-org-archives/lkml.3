Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab3CAQIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:08:53 -0500
Received: from zfrontend1.aha.ru ([195.2.83.147]:37703 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751059Ab3CAQIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:08:52 -0500
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Mar 2013 11:08:51 EST
From: "werner" <w.landgraf@ru.ru>
Subject: Re: Linux 3.8-rc1: compiling problem in perf-event-p6.o
To: rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Fri, 01 Mar 2013 11:08:45 -0400
Message-ID: <web-850647262@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That should be corrected, even if it's a problem of the CC 
version / libries, or not,   compilation can't depend on 
this, code can't be so non-standard that it depends on the 
compiler version.

wl




=====================================

The problem continues with 3.8-rc

This is grave, no vmlinuz is produced.


wl

   CC arch/x86/kernel/cpu/perf_event.o
   CC arch/x86/kernel/cpu/perf_event_amd.o
   CC arch/x86/kernel/cpu/perf_event_p6.o
arch/x86/kernel/cpu/perf_event_p6.c:22: error: 
p6_hw_cache_event_ids causes a section type conflict
make[3]: [arch/x86/kernel/cpu/perf_event_p6.o] Error 1 
(ignored)
   CC arch/x86/kernel/cpu/perf_event_knc.o
   CC arch/x86/kernel/cpu/perf_event_p4.o
   CC arch/x86/kernel/cpu/perf_event_intel_lbr.o
---
Professional hosting for everyone - http://www.host.ru
