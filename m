Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbaCRVxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:53:48 -0400
Received: from imap.thunk.org ([74.207.234.97]:43199 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749AbaCRVxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:53:45 -0400
Date: Tue, 18 Mar 2014 17:52:57 -0400
From: tytso@mit.edu
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] RDSEED support for the Linux kernel
Message-ID: <20140318215257.GA19887@thunk.org>
Mail-Followup-To: tytso@mit.edu, "H. Peter Anvin" <hpa@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Michael Ellerman <michael@ellerman.id.au>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1395099390-807-1-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395099390-807-1-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 04:36:26PM -0700, H. Peter Anvin wrote:
> Changes since version 1:
> 
> a. Rebased on top of random.git:dev.
> b. Unbreak the PowerPC build (I had managed to miss that PowerPC had
>    grown archrandom.h support.)
> c. Remove duplicate dummy function definitions in <linux/random.h>.
> d. Add a fourth patch containing a microoptimization: avoid the loop
>    in arch_random_refill() if arch_get_random_seed*() is unavailable.
> 
> Comments are, of course, appreciated.
> 
> Ted, if you are OK with this could you add this to random.git:dev so
> linux-next can pick it up?

Thanks, applied to the random.git tree.

					- Ted
