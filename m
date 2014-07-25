Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935213AbaGYUHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 16:07:35 -0400
Received: from relais.videotron.ca ([24.201.245.36]:13726 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaGYUHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 16:07:34 -0400
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v2 0/5] generic IPI tracing
Date: Fri, 25 Jul 2014 16:05:28 -0400
Message-id: <1406318733-26754-1-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of the series initially posted here:

http://news.gmane.org/group/gmane.linux.kernel/thread=1750391

Steven / Ingo: Would you please merge those patches in your tree for some 
linux-next exposure and mainline inclusion? Patches 1 to 4 may go in now. 
I'm unsure about patch 5 so I'll leave it to your appreciation.

Changes since v1:

- added empty tracepoint_string when !CONFIG_TRACING, from Steven
- ipi_types[] is unconditionally marked with __tracepoint_string now
- added comment to arch/x86/kernel/smp.c justifying the #undef's
- collected ACKs, refined commit logs

diffstat:

 arch/arm/kernel/smp.c        | 70 ++++++++++++++++++------------
 arch/arm64/kernel/smp.c      | 65 +++++++++++++++++-----------
 arch/x86/kernel/smp.c        | 20 +++++++++
 include/linux/ftrace_event.h | 10 +++++
 include/trace/events/ipi.h   | 89 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 200 insertions(+), 54 deletions(-)


Nicolas

