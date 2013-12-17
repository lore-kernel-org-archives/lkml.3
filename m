Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3LQMqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:46:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41635 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3LQMqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:46:07 -0500
Message-Id: <20131217122720.950475833@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 17 Dec 2013 13:27:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 00/13] sched, deadline: patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hai..

This is my current queue of SCHED_DEADLINE; which I hope to merge 'soon'.

Juri handed me a version that should've (didn't check) included all feedback
including the new sched_attr interface.

I did clean up some of the patches; moved some hunks around so that each patch
compiles on its own etc..

I then did a number of patches at the end to change some actual stuff around.

Juri do you have some userspace around to test with? I'm just too likely to
have wrecked everything; so if you don't have something I need to go write
something before merging this :-)

No need to update your test proglets to the new interface, I can lift it if
that is more convenient -- I know you're conferencing atm.

One question; the SoB chain in patch 2/13 seems weird; I suppose that
patch is a collaborative effort? could we cure that by mentioning Fabio
and Michael in some other way?

