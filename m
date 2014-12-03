Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaLCSBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:01:42 -0500
Received: from smtprelay0170.hostedemail.com ([216.40.44.170]:36225 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750893AbaLCSBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:01:41 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:2915:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4470:5007:6119:6261:7875:7903:8531:10004:10400:10848:10967:11232:11658:11914:12050:12517:12519:12663:12740:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rest09_659ef8fe3e329
X-Filterd-Recvd-Size: 2298
Date: Wed, 3 Dec 2014 13:01:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ftracetests: Add test to test event filter logic
Message-ID: <20141203130134.117af4be@gandalf.local.home>
In-Reply-To: <CAMEtUuxjCQ_eZ9aMmzKWvQw55DO7vgVDN-8neAwR8W+Xdu3zwg@mail.gmail.com>
References: <20141203031334.174087814@goodmis.org>
	<20141203032106.156623189@goodmis.org>
	<CAMEtUuyzfKYVSJUra6nib-wWYQ91uEPC6mizF9PLpg+5Kjb+3w@mail.gmail.com>
	<20141203034033.19a30e2f@gandalf.local.home>
	<CAMEtUuxjCQ_eZ9aMmzKWvQw55DO7vgVDN-8neAwR8W+Xdu3zwg@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014 09:53:18 -0800
Alexei Starovoitov <ast@plumgrid.com> wrote:

 
> aren't we all starting to hack things only to realize
> that the scope of work is too large? ;)

Yep. Although I did say I would only spend a few hours on a solution,
and would give up if it too longer. The patches themselves took much
shorter than I expected. It was writing the tests that brought me over
the brink. Although, I did a lot of manual tests to make sure things
did what was expected. But those manual tests need to become automatic
ones.


> Anyway, will try to add these tests when your patches land.

I'm placing the code changes in my 3.19 queue, and the test cases in my
3.20 queue. This is probably a good idea anyway, as the test cases will
fail if the code wasn't implemented, and the test goes in a separate
branch, where the code isn't implemented :-)  I did a merge to do the
test cases.

I also need to solve the busybox limitation. I don't know how that
shell can do bit logic, which is needed to verify that the filters
really did work.

-- Steve 
