Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3EGRmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 13:42:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51282 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3EGRmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 13:42:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [GIT PULL] ARM: Third batch of arm-soc changes for 3.10
Date: Tue, 7 May 2013 19:42:12 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1367942534-2934003-1-git-send-email-arnd@arndb.de> <CA+55aFwMXmJ9V+3o62ELm-0NT1DaUCTvidmAhJSXzQcTMfJygA@mail.gmail.com> <20130507173231.GL18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130507173231.GL18614@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305071942.12709.arnd@arndb.de>
X-Provags-ID: V02:K0:DuHKTKRUeOlUpDPakzvoLtCeCnwew22Ymhe8EYJpw/u
 J+melfWUP9SXW2DijTNdT3nGdFd5DuxxOqXq4Pw6gHqGiE0JWS
 5hPbD3DZcjH+S8UjclRLQHdgfuO9c0dCGt62IDHPwQhBr7/qY8
 2bVvaU3AWQmS+EyNqzZL1ckAWsbheSNIkAdfmLL/w7JXfaBsqs
 6SFGYAUKl42LVQsY2LX3nOaUglsERjNviW1IkgoaK4dCn7PVfe
 Msl2vORpVDZOyMfW7vKX491g9olrdIj9+7okVdRftmKzIK2EzA
 scEJViD42wnV9ZHOheuhYV6h4FA19gePCszFg4OWAC0HTwaLE9
 OMugALYEVJzLJtLoi/sE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 May 2013, Russell King - ARM Linux wrote:
> On Tue, May 07, 2013 at 10:02:22AM -0700, Linus Torvalds wrote:
> > So you seem to have blasted this series out with that automated
> > script, so they all got sent basically at the same timestamp, and they
> > are in the wrong order in my mailbox because email isn't that ordered.
> 
> Interesting.  What I received here from the mailing list from Arnd
> was:
> 
> Date: Tue,  7 May 2013 18:02:09 +0200
> Subject: [GIT PULL] ARM: Third batch of arm-soc changes for 3.10
> 
> Date: Tue,  7 May 2013 18:02:10 +0200
> Subject: [GIT PULL] ARM: arm-soc platform updates for 3.10, part 2
> 
> Date: Tue,  7 May 2013 18:02:11 +0200
> Subject: [GIT PULL] ARM: arm-soc platform updates for 3.10, part 3
> 
> Date: Tue,  7 May 2013 18:02:12 +0200
> Subject: [GIT PULL] ARM: arm-soc device tree changes, part 2
> 
> Date: Tue,  7 May 2013 18:02:13 +0200
> Subject: [GIT PULL] ARM: arm-soc: late cleanups
> 
> Date: Tue,  7 May 2013 18:02:14 +0200
> Subject: [GIT PULL] ARM: arm-soc: late Exynos multiplatform changes
> 
> So they do each have a different timestamp, and do come out right if
> sorted by date-sent.  Maybe one second is not long enough for gmail to
> sort by date-sent?  Sure, allowing a longer delay reduces the
> possibility of stuff being reordered by MTAs, but it will never totally
> eliminate that reordering - it just makes it less likely.

Interestingly, the second version (with sequence numbers) has exactly the
same seconds, but 19:26 instead of 18:02 as the hour:minute. There is
probably some intentional logic in there that fills in these numbers.
I'm sure I waited more than a couple of seconds between each email this
time around, where the first time I just sent them all without any delay.

> So I don't think that asking people to play games with delays between
> consecutive messages is going to work all that well.
> 
> The only sure way would be to have it clearly marked in the subject
> line, maybe in a similar way to how we mark patches using a
> [GIT PULL N/M] thing.

Yes, that is certainly the right way to do it. I'm also very relieved
that this time lists.infradead.org didn't reject all emails sent in
reply to the introductory mail, which it previously did based on the
ground that it had an "in-reply-to" header to a mail with a different
subject.

	Arnd
