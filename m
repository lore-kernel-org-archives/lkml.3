Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752AbaLAWKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:10:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932570AbaLAWKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:10:13 -0500
Date: Mon, 1 Dec 2014 23:09:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Waiman Long <Waiman.Long@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86, ticketlock: spin_unlock_wait() can livelock
Message-ID: <20141201220929.GA7305@redhat.com>
References: <20141201213357.GA5834@redhat.com> <20141201213417.GA5842@redhat.com> <CA+55aFz6a99n_bGGi0CrOeWA3KRVdAJtPiF_3iP1aVx_wE+mMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz6a99n_bGGi0CrOeWA3KRVdAJtPiF_3iP1aVx_wE+mMA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01, Linus Torvalds wrote:
>
> Can you point to the report that you
> think this might be the cause of?

Please look at https://bugzilla.redhat.com/show_bug.cgi?id=1128995

but let me repeat, so far this is just my speculation. Plus this is
the old rhel6 kernel.

Oleg.

