Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaDRTF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 15:05:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59612 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbaDRTFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 15:05:44 -0400
Date: Fri, 18 Apr 2014 21:05:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v9 05/19] qspinlock: Optimize for smaller NR_CPUS
Message-ID: <20140418190519.GA11182@twins.programming.kicks-ass.net>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
 <1397747051-15401-6-git-send-email-Waiman.Long@hp.com>
 <20140417155649.GR11096@twins.programming.kicks-ass.net>
 <53504BB3.4010009@hp.com>
 <20140418082716.GZ11096@twins.programming.kicks-ass.net>
 <53516672.3010701@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53516672.3010701@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 01:52:50PM -0400, Waiman Long wrote:
> I am confused by your notation.

Nah, I think I was confused :-) Make the 1 _Q_LOCKED_VAL though, as
that's the proper constant to use.
