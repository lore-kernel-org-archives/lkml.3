Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3LLOWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:22:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36059 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab3LLOVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:21:18 -0500
Message-Id: <20131212140835.729222186@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 12 Dec 2013 15:08:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/15] cleanups and optimizations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains the preempt_enable_no_resched() cleanups that include
spin_lock_bh() optimizations and local_clock() optimizations.

This patch series does not include the generic idle loop stuff used to 'fix'
the idle injection crap. Rafael, can we make that happen by simply ignoring
pm-qos like they already do, that way we at least have that part of the
cleanups done and you and Jacub can sort the pm-qos stuff at your own leasure.

Thomas, can you merge this series?

