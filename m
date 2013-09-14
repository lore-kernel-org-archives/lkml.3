Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab3INTsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 15:48:19 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47106 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932242Ab3INTsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 15:48:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2] timekeeper latch synchronization
Date: Sat, 14 Sep 2013 12:47:54 -0700
Message-Id: <1379188081-15613-1-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is my timekeeper latch synchronization series update, still as RFC.
It now passes the timetests provided by John Stultz
(https://github.com/johnstultz-work/timetests.git). See the changelog of
"Introduce timekeeper latch synchronization" to get a clear picture of
all the goodness introduced by this scheme. ;-)

Comments are welcome,

Thanks!

Mathieu

