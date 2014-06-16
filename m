Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827AbaFPSLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:11:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:39480 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208AbaFPSLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:11:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,488,1400050800"; 
   d="scan'208";a="558372300"
Message-ID: <1402942741.15603.25.camel@rage>
Subject: Re: [patch 4/5] futex: Split out the first waiter attachment from
 lookup_pi_state()
From: Darren Hart <darren@dvhart.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Kees Cook <kees@outflux.net>, wad@chromium.org
Date: Mon, 16 Jun 2014 11:19:01 -0700
In-Reply-To: <20140611204237.271300614@linutronix.de>
References: <20140611202744.676528190@linutronix.de>
	 <20140611204237.271300614@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 20:45 +0000, Thomas Gleixner wrote:
> We want to be a bit more clever in futex_lock_pi_atomic() and separate
> the possible states. Split out the code which attaches the first
> waiter to the owner into a separate function. No functional change.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed for functional equivalence:

Reviewed-by: Darren Hart <darren@dvhart.com>

-- 
Darren Hart
Intel Open Source Technology Center


