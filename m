Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaJWK74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:59:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:35966 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaJWK7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:59:50 -0400
Message-Id: <20141023105119.173457103@infradead.org>
User-Agent: quilt/0.61-1
Date: Thu, 23 Oct 2014 12:51:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, ak@linux.intel.com,
        eranian@google.com, dzickus@redhat.com, andi@firstfloor.org,
        jmario@redhat.com, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, "Peter Zijlstra" <peterz@infradead.org>
Subject: [PATCH 0/4] Attempt to cleanup the HSW offcore bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So Don asked about offcore and because I forgot I looked at the code and found
the terrible mess Andi created with the HSW/BDW bits.

This series attempts to clean some of that up but seeing how it was all magic
numbers and no reasons provided for the differences with existing uarchs this
might just break things horribly.

That said, if this does break things, fixes will have to explain things, so
that's good.

