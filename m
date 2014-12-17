Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaLQJwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:52:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38110 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbaLQJw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:52:29 -0500
Date: Wed, 17 Dec 2014 10:52:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Kevin Cernekee <cernekee@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>, gnomes@lxorguk.ukuu.org.uk,
        Brian Norris <computersforpeace@gmail.com>,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/4] Stop maintainer abuse
Message-ID: <20141217095227.GA8457@pd.tnic>
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
 <20141216130939.166c4369@lwn.net>
 <CAJiQ=7B76vE2ctYd2GK5+_whNnLGKtUY65qkMLdewBqfO7HfPg@mail.gmail.com>
 <20141216223133.GB5656@pd.tnic>
 <20141217051424.GZ17575@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141217051424.GZ17575@thunk.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 12:14:24AM -0500, Theodore Ts'o wrote:
>  And what's wrong for one maintainer will be right for another, and
> vice versa.

Ok, so what's wrong with "should not expect any feedback during the
merge window"?

If they get it, then that's fine. The formulation is loose on purpose.

And besides, when one starts working with maintainers, one soon learns
when they are the busiest and can refrain from sending patchsets then.

Or should we have subsystem maintainers each state whether they wanna
do patchsets during the merge window or not? Or are we bikeshedding
already?

I see your point that different maintainers can be busy at different
times but you also have to acknowledge the desire of some maintainers
not to get new patchsets during the merge window. So we have to have a
way to communicate that to submitters so that no explosions happen.

Oh, and also the
not-resend-in-under-a-week-and-wait-out-complete-review-first rule.
That's my personal pet peeve.

Ha, this sounds like a KS topic :-P

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
