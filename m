Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbaA1RhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:37:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60574 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbaA1Rds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:33:48 -0500
Message-Id: <20140128171634.974847076@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 28 Jan 2014 18:16:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, daniel.lezcano@linaro.org, pjt@google.com,
        bsegall@google.com, Steven Rostedt <rostedt@goodmis.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/9] Various sched patches -v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a set that seems to work properly and hopefully adresses all previously
raised issues.

Daniel, I'm sorry, the idle_stamp thing wandered back over to fair.c :-)

I did test the fair bits, including bandwidth (although not very
extensively).

I did not test the dl/rt bits, Steve do you have a testcase for that?

