Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3KLWkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:40:19 -0500
Received: from dmz-mailsec-scanner-6.mit.edu ([18.7.68.35]:52028 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757013Ab3KLWkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 17:40:13 -0500
X-AuditID: 12074423-b7f2b6d000000ce1-49-5282ae4c7a9f
Date: Tue, 12 Nov 2013 17:40:09 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 00/11] random: code cleanups
Message-ID: <20131112224009.GX8043@ringworld.MIT.EDU>
References: <cover.1383868558.git.price@mit.edu>
 <20131112042444.GC30281@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112042444.GC30281@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsUixG6nouu7rinI4EAno8XuOYtZLC7vmsPm
	wORxZsERdo/Pm+QCmKK4bFJSczLLUov07RK4Ml7+/MlUMIe74tDTycwNjH85uhg5OSQETCT+
	XdvMBGGLSVy4t56ti5GLQ0hgNpPE4b8XmSGcjYwS66eeY4FwfjFKHDw6jwWkhUVAVeJjXwOY
	zSagIPFj/jpmEFtEIFPi14zpYGOFBQwkdu3sAqvhFTCV6FpxkRHEFhIIlbj1fCoTRFxQ4uTM
	J2A1zAJaEjf+vQSKcwDZ0hLL/4FdyimgL9G9by5YiaiAisSUk9vYJjAKzELSPQtJ9yyE7gWM
	zKsYZVNyq3RzEzNzilOTdYuTE/PyUot0zfRyM0v0UlNKNzGCg9RFeQfjn4NKhxgFOBiVeHgt
	YpqChFgTy4orcw8xSnIwKYnyRqwFCvEl5adUZiQWZ8QXleakFh9ilOBgVhLhlV4DlONNSays
	Si3Kh0lJc7AoifPe4rAPEhJITyxJzU5NLUgtgsnKcHAoSfDeBRkqWJSanlqRlplTgpBm4uAE
	Gc4DNPw4SA1vcUFibnFmOkT+FKOilDjvZZCtAiCJjNI8uF5YEnnFKA70ijDvMZB2HmACgut+
	BTSYCWiwRTHY4JJEhJRUA6MVS96haNb6+QrOq4Rt5MOWbBP7HrF69nf/o0x/8w7NWFy5fvWU
	LQ+KGmzXLeW55LRlbYXBowqJEx3vOJ+a+JyZ2Rva275OaZLhK8tEc/7mV4/ZbGU4b9asEbn+
	cupy6eN8cy5/6VqUpTHvADP3oSDd4k1nF6rpzpS9s/5V5ymR1PfO33xsGqyUWIozEg21mIuK
	EwH5KBmh/QIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 11:24:44PM -0500, Theodore Ts'o wrote:
> My apologies for not being able to get to this patch series before the
> patch window opened --- this week has been crazy.  None of the changes
> seem to be especially critical, and a number of the patches don't
> apply cleanly to the random.git tree (some of the spelling fixes have
> already been fixed, for example), which has patches queued up for the
> upcoming merge window.  So I'm going to defer applying these patches
> for 2.13, and I'd ask you if you'd be willing to rebase these patches
> against the random.git tree, so they can be pulled in after the merge
> window closes.

Ah, I hadn't spotted the random.git tree!  Looks like 'dev' at
v3.11-20-g392a546 is the tip -- is that right?  Rebasing now, and I'll
follow up with the result.

I agree that none of the changes are especially critical.  There is
one bugfix, and the rest are code cleanups.

Beyond these easy cleanups, I have a couple of patches queued up (just
written yesterday, not quite finished) to make /dev/urandom block at
boot until it has enough entropy, as the "Mining your P's and Q's"
paper recommended and people have occasionally discussed since then.
Those patches were definitely for after 3.13 anyway, and I'll send
them when they're ready.  I see some notifications and warnings in
this direction in the random.git tree, which is great.

Cheers,
Greg
