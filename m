Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab3LMNXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 08:23:32 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:65239 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab3LMNXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 08:23:30 -0500
Date: Fri, 13 Dec 2013 14:23:25 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alexander Holler <holler@ahsoftware.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        "Theodore Ts'o" <tytso@mit.edu>, vegard.nossum@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <james.l.morris@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/9] Known exploit detection
Message-ID: <20131213132325.GB10981@gmail.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
 <20131212190659.GG13547@thunk.org>
 <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
 <20131213002523.GA20706@redhat.com>
 <20131213014220.GB11068@kroah.com>
 <52AAE214.7020109@ahsoftware.de>
 <20131213114841.GA5443@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213114841.GA5443@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Fri, Dec 13, 2013 at 11:31:48AM +0100, Alexander Holler wrote:
> > I've never seen a comment inside the kernel sources which does point
> > to a CVE, so I assume there already does exists some agreement about
> > not doing so.
> 
> We do occasionally put CVE numbers in the commit message, but 
> normally the commit comes first before we ask for a CVE number.

The detection code will most likely come after the fix is applied.

In that case the 'ID' of the message could also be the commit ID of 
the fix in question:

	detect_exploit("[exploit for d8af4ce490e9: Fix syscall bug]")

or so - no CVE needed, it's a free form ID that can contain anything 
descriptive about the bug the attacker attempted to exploit.

Thanks,

	Ingo
