Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaIVUIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:08:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54374 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbaIVUIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:08:14 -0400
Date: Mon, 22 Sep 2014 22:08:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] x86: Use volatile semantics for atomic_set()
Message-ID: <20140922200806.GC3128@worktop.programming.kicks-ass.net>
References: <1411414762-32366-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411414762-32366-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 03:39:21PM -0400, Pranith Kumar wrote:
> All the atomic operations have volatile semantics to prevent compiler
> reordering. Enforce the same semantics for atomic_set() too.

To what point? atomic_set() is typically not what you expect it to
anyhow.
