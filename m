Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbbAZUEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:04:42 -0500
Received: from mail.efficios.com ([78.47.125.74]:58793 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbbAZUEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:04:40 -0500
Date: Mon, 26 Jan 2015 20:04:45 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: lttng-dev@lists.lttng.org
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <1224618254.53158.1422302685749.JavaMail.zimbra@efficios.com>
In-Reply-To: <314636431.53126.1422302376219.JavaMail.zimbra@efficios.com>
Subject: [RELEASE] LTTng modules 2.6.0 (Gaia)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.246.22.116]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF35 (Linux)/8.0.7_GA_6021)
Thread-Topic: LTTng modules 2.6.0 (Gaia)
Thread-Index: NS7Bq2lIbwRtvaKLVS89qZrlgDxSEA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are now releasing the 2.6.0 LTTng modules Linux kernel tracer.

New & Noteworthy features in the LTTng Linux kernel tracer 2.6.0: 

- System call filtering! Fine-tune which system calls you want
  to trace or not,
- We now gather in/out parameters of system calls at entry and
  exit of the syscall. Please note that the system call event
  semantic (naming) have changed in this release. You may have
  to update your analysis if they depended on the old semantic,
- Trace NMI handlers, using the new NMI-safe clock monotonic
  available in kernels >= 3.17.

Changelog since LTTng modules 2.6.0-rc2:

2015-01-26 LTTng modules 2.6.0
        * Fix: missing parenthesis in offset_align_floor
        * Fix: implement time.h wrapper for FD_ISSET
        * Fix: update sched instrumentation for 3.19+ kernels
        * Fix: update rcu instrumentation for 3.19+ kernels
        * Fix: update scsi instrumentation for 3.19+ kernels
        * Fix: update module instrumentation for 3.19+ kernels
        * Fix: Add f_dentry wrapper for 3.19+ kernels
        * Fix: introduce lttng_get_unused_fd() wrapper for 3.19 kernels
        * Fix: lttng_this_cpu_ptr wrapper for kernel 3.19+
        * Fix: Update btrfs instrumentation for 3.18 Linux kernel
        * Fix compile error on kernel 3.0.101 with CONFIG_PERF_EVENTS
        * Conditional compilation introduced by lttng-modules commit

Project website: http://lttng.org
Documentation: http://lttng.org/docs
Download link: http://lttng.org/download

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
