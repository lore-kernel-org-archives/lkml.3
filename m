Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaCYIjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:39:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbaCYIjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:39:21 -0400
Date: Tue, 25 Mar 2014 04:38:44 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.14-rc8
Message-ID: <20140325083844.GA2516@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFzFj_XMNha5gcDHfmLE_Jb-O2OpdTbZyQdarJnip1gSBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzFj_XMNha5gcDHfmLE_Jb-O2OpdTbZyQdarJnip1gSBQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 07:40:06PM -0700, Linus Torvalds wrote:
 > I delayed things a day from my normal schedule, hoping I'd feel more
 > comfortable doing a 3.14 release, but that was not to be. So here's an
 > rc8, and I expect to do the final 3.14 release next weekend.
 > 
 > There wasn't that much scary stuff going on, but there's a few vfs
 > fixes still pending, and we did end up having some interesting core
 > fixes last week too (not new regressions, but newly detected by
 > Trinity. Kudos to Hugh Dickins for figuring them out and fixing the
 > causes). There's also some networking fixes and random noise (mainly
 > MIPS).  So I really wanted another week before release after all.

FWIW, since Hugh's heroic work nailing those bugs, I've managed to run
trinity for days since without problems[1]. As we discussed today at the VM summit,
Sasha has found a bunch of things in -next that may be a problem in .14 too, 
(and in fact I've hit one of those BUGONs once), but on the whole it's looking
a lot better.

	Dave

[1] Actually, I've since crashed my test box for stupid reasons now that
    I'm 3000 miles away from it until the end of the week, but I have a way better
    opinion of rc8 than I did of rc7.

	Dave

