Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3DON5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:57:04 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:43144 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3DON5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:57:03 -0400
MIME-Version: 1.0
Date: Mon, 15 Apr 2013 15:57:00 +0200
X-Google-Sender-Auth: hGblqu1Mq9hWzrfmErTgeoLwK8E
Message-ID: <CA+xJJ18xR+j6cf+nD_VUwXS3BJta_dZMWs+ih5CMB_5LN=Q8VA@mail.gmail.com>
Subject: Trouble with full nohz and lttng
From: Mats Liljegren <mats.liljegren@enea.com>
To: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I use lttng, I keep getting ticks. Without lttng, no ticks. It's
the same application I run, the same way. The only difference is
whether lttng logging has been started or not.

The trace says "sched" as reason for not disabled ticks. Using "top" I
can't see any extra process/thread being created while my application
runs, my application gets 99-101% of the CPU. There are a couple of
kworker threads (3), a migration thread and a ksoftirq thread on the
same CPU as my application, though "top" gives no indication that they
do any execution.

Is this a known limitation of lttng, or is there something else going on here?

/Mats
