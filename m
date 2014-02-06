Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbaBFLpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 06:45:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46678 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbaBFLpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 06:45:34 -0500
Date: Thu, 6 Feb 2014 12:45:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-arch@vger.kernel.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: mips octeon memory model questions
Message-ID: <20140206114517.GI4941@twins.programming.kicks-ass.net>
References: <20140204184150.GB5002@laptop.programming.kicks-ass.net>
 <52F144C3.1080705@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F144C3.1080705@caviumnetworks.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 11:51:31AM -0800, David Daney wrote:
> On OCTEON, SC implies a SYNC operation for the target memory location. So
> the "SC b" is ordered before any writes that come after the SC.

Ah, that makes it all come together. I was thrown by octeon initially
having WEAK_REORDERING_BEYOND_LLSC set and thus thinking there were no
implied barriers.

Thanks David.
