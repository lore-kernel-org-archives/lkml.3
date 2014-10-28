Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaJ1MlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:41:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:58233 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaJ1MlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:41:09 -0400
Message-Id: <20141028123043.257488788@infradead.org>
User-Agent: quilt/0.61-1
Date: Tue, 28 Oct 2014 13:30:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, ak@linux.intel.com,
        eranian@google.com, dzickus@redhat.com, andi@firstfloor.org,
        jmario@redhat.com, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/3] Cleanup of the HSW offcore bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So Don asked about offcore and because I forgot I looked at the code and found
the terrible mess Andi created with the HSW/BDW bits.

This series attempts to restore sanity and supposedly uses the right bits for
the hardware.

That said, again, if this breaks things, fixes will have to come with
explanations, not magic.


