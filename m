Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbaGQWaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 18:30:39 -0400
Received: from imap.thunk.org ([74.207.234.97]:41956 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbaGQWah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 18:30:37 -0400
Date: Thu, 17 Jul 2014 18:30:29 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Bob Beck <beck@openbsd.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-api <linux-abi@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140717223029.GY1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Bob Beck <beck@openbsd.org>, Christoph Hellwig <hch@infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-api <linux-abi@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org>
 <20140717170115.GO1491@thunk.org>
 <CAComcpM9-sUwzT9BPFT7BJjk97V0kj996D=AaivDpeTZUNbiew@mail.gmail.com>
 <20140717173433.GQ1491@thunk.org>
 <CAComcpPkOM9oy9tYcDqVfF3siKT_RLe54qskhUJRPLWm-MukEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAComcpPkOM9oy9tYcDqVfF3siKT_RLe54qskhUJRPLWm-MukEA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 11:45:56AM -0600, Bob Beck wrote:
> we have diffs pending that will do the syscall method until we start
> to see it in libc :)

One warning --- please don't check in the syscall number until it
actually hits mainline.  Kees has another patch outstanding for
seccomp(2) that is using the same syscall numbers I have in my patch.
Please treat the numbers in my patch as placeholders until it has been
accepted and we see what numbers we actually get assigned.

Thanks,

						- Ted
