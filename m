Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbaDGOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:16:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46677 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaDGOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:16:56 -0400
Date: Mon, 7 Apr 2014 16:16:36 +0200
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
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v8 01/10] qspinlock: A generic 4-byte queue spinlock
 implementation
Message-ID: <20140407141636.GM10526@twins.programming.kicks-ass.net>
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
 <1396445259-27670-2-git-send-email-Waiman.Long@hp.com>
 <20140404130012.GE10526@twins.programming.kicks-ass.net>
 <533EC8BD.8080601@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533EC8BD.8080601@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 10:59:09AM -0400, Waiman Long wrote:
> I am really sorry if you have bad feeling about it. I do not mean to
> discredit you on your effort to make the qspinlock patch better. I really
> appreciate your input and would like to work with you on this patch as well
> as other future patches.

OK.. that'd be great. Sorry if I sound somewhat cranky (well I am, of
course) partly this is because jet-lag and partly because I just get
grumpy from the Inbox after travel.


