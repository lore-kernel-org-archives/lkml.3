Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761636Ab3IDBal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:30:41 -0400
Received: from mail.openrapids.net ([64.15.138.104]:34816 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755777Ab3IDBak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:30:40 -0400
Date: Tue, 3 Sep 2013 21:30:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: lttng-dev@lists.lttng.org
Cc: lwn@lwn.net, linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng modules 2.3.0
Message-ID: <20130904013037.GB25652@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LTTng modules provide Linux kernel tracing capability to the LTTng
2.x tracer toolset.

Noteworthy changes:
- Support for Linux kernels up to (including) 3.11,
- Flight recorder (snapshot) support,
- Updated ARM, x86 system call instrumentation,
- Add 32-bit PowerPC system call instrumentation.

Changelog since 2.3.0-rc2:
2013-09-03 LTTng modules 2.3.0
        * Fix: metadata stream should not reference session
        * Fix: btrfs: support 3.11 Linux kernel
        * statedump: remove KERN_DEBUG messages
        * Fix: ext4: add missing tracepoints for 3.11 kernel
        * Fix: ext4: Linux 3.11 support
        * Fix: ext3: 3.11 Linux support
        * Fix: statedump nsproxy 3.11 Linux support

Project website: http://lttng.org
Download link: http://lttng.org/download
(please refer to the README files for installation instructions and
lttng-tools doc/quickstart.txt for usage information)

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
