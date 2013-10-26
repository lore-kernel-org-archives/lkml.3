Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab3JZLco (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 07:32:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59674 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3JZLcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 07:32:43 -0400
Date: Sat, 26 Oct 2013 13:32:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131026113238.GC1792@Nokia-N900>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <20131025091842.GA28681@thunk.org>
 <20131025022937.12623dcd.akpm@linux-foundation.org>
 <CA+55aFzq4-wsErRO56gW6gj3Q91QtvvaGQPdUV2JkSs-B1PCAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzq4-wsErRO56gW6gj3Q91QtvvaGQPdUV2JkSs-B1PCAQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2013-10-25 10:32:16, Linus Torvalds wrote:
> On Fri, Oct 25, 2013 at 10:29 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > Apparently all this stuff isn't working as desired (and perhaps as designed)
> > in this case.  Will take a look after a return to normalcy ;)
> 
> It definitely doesn't work. I can trivially reproduce problems by just
> having a cheap (==slow) USB key with an ext3 filesystem, and going a
> git clone to it. The end result is not pretty, and that's actually not
> even a huge amount of data.

Hmm, I'd expect the result to be "dead USB key". Putting
ext3 on cheap flash device normally just kills the devic :-(.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
