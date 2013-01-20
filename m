Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab3ATT4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 14:56:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab3ATT4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 14:56:50 -0500
Date: Sun, 20 Jan 2013 20:55:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Vagin <avagin@parallels.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andrey Wagin <avagin@gmail.com>, David Howells <dhowells@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, criu@openvz.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [CRIU] [PATCH 2/3] signalfd: add ability to return siginfo in
	a raw format (v2)
Message-ID: <20130120195555.GA14177@redhat.com>
References: <1358182435-19245-1-git-send-email-avagin@openvz.org> <1358182435-19245-3-git-send-email-avagin@openvz.org> <20130116123502.70af6b85.akpm@linux-foundation.org> <CAKgNAkgHVB3=k_XOevobcMWuEqy2r75tdTc85ZYiD8rkn5OZKA@mail.gmail.com> <CANaxB-wXdPZFzD3BhkD6niDA6M1NiNrc5coKf9bSx+ar_fZecg@mail.gmail.com> <CAKgNAkjK9iWh_PuJ92A-MKW6Q6_B8DvTL5-fkxyULqx9ZoDPfg@mail.gmail.com> <20130120174153.GA5675@paralelels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130120174153.GA5675@paralelels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20, Andrew Vagin wrote:
>
> > SFD_RAW
> > SFD_SHARED_QUEUE -- reads will be from process-wide shared signal queue
> > SFD_PER_THREAD_QUEUE --reads will be from per-thread signal queue
>
> I suggested this variant in the initial series, but then we decided to
> avoid adding new flags.

Yes, because SFD_SHARED/PRIVATE will add even more complications into this
code. And outside of signalfd.c too. And nobody except c/r will ever use
these features I guess.

> Oleg, what do you think about this?

See above... but as I said from the very beginning I won't insist.

Oleg.

