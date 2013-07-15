Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab3GOVeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:34:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50928 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754002Ab3GOVeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:34:08 -0400
Message-ID: <1373924046.2062.43.camel@joe-AO722>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Willy Tarreau <w@1wt.eu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 15 Jul 2013 14:34:06 -0700
In-Reply-To: <1373923281.17876.208.camel@gandalf.local.home>
References: <1373916476.2748.69.camel@dabdike>
	 <1373917517.17876.193.camel@gandalf.local.home>
	 <20130715195505.GE10157@1wt.eu>
	 <1373921779.17876.200.camel@gandalf.local.home>
	 <1373922593.2062.36.camel@joe-AO722>
	 <1373923281.17876.208.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 17:21 -0400, Steven Rostedt wrote:
> How many maintainers are really just volunteers?

No idea.  Here's a data point.

$ git grep "^S:" MAINTAINERS|sed -r 's/\s+/ /g'|sort|uniq -c|sort -rn
    818 MAINTAINERS:S: Maintained
    248 MAINTAINERS:S: Supported
     49 MAINTAINERS:S: Odd Fixes
     32 MAINTAINERS:S: Orphan
     10 MAINTAINERS:S: Odd fixes
      2 MAINTAINERS:S: Unmaintained
      1 MAINTAINERS:S: Orphan / Obsolete
      1 MAINTAINERS:S: Odd Fixes (e.g., new signatures)
      1 MAINTAINERS:S: Obsolete
      1 MAINTAINERS:S: Maintained for 2.6.
      1 MAINTAINERS:S: Maintained:
      1 MAINTAINERS:S: Buried alive in reporters

I will note that most MAINTAINER section entries
don't actually have people actively shepherding
patches.  There's no aging out of inactive entries.

> And of those, how many have critical parts of the kernel
> that distros rely on.

No idea.  I'd guess most distributions don't go
out of their way to hire folk when "good enough"
seems to be working.

> If they do, then one would think that a distro
> would hire them.


