Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab3A0Od4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 09:33:56 -0500
Received: from taos.firemountain.net ([207.114.3.54]:12714 "EHLO
	taos.firemountain.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab3A0Ody (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 09:33:54 -0500
X-Greylist: delayed 1025 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2013 09:33:54 EST
Date: Sun, 27 Jan 2013 09:16:39 -0500
From: Rich Kulawiec <rsk@gsp.org>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>
Subject: Re: Friendlier EPERM - Request for input
Message-ID: <20130127141639.GA3028@gsp.org>
References: <1357747463.2593.28.camel@localhost>
 <1357760637.2593.55.camel@localhost>
 <201301110014.CDB90164.MFtFHVSQOFOJLO@I-love.SAKURA.ne.jp>
 <1357835679.1342.45.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357835679.1342.45.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 11:34:39AM -0500, Eric Paris wrote:
> This is not the point I am arguing.  This is not about LSMs, how hard
> they are to configure, or how to 'fix' them.  It certainly isn't about
> how one LSM is better, easier, or superior to another.  This is about
> getting more information in userspace when operations fail.  I'll quote
> an off list e-mail I received:
> 
> Friendlier/more complete error messages would eliminate an awful lot of
> digging around trying to figure *what* the problem is, preparatory to
> discerning *where* the problem is and *how* to fix it.

I know I'm a bit late to this, but Eric's quoting me, and I thought
I should stand behind my words publicly.

I often find myself confronted with systems that I didn't build, haven't
maintained, have no documentation for, and are broken in odd/puzzling
ways.  There's also sometimes a bit of duress due to externally imposed
time constraints.  I of course don't expect anyone else to solve those
problems, but it would be awfully handy if there was a breadcrumb trail
to follow.

So to borrow Eric's phrase, "getting more information in userspace when
operations fail", would be an entirely good thing.  I'll defer entirely to
others in the discussion thread about how that might be best accomplished,
but I'd like to express my full support for the end goal.

---rsk
