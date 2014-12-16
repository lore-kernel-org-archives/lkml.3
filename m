Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaLPIGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:06:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:41923 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaLPIGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:06:43 -0500
Message-ID: <1418717184.5111.75.camel@kernel.crashing.org>
Subject: Re: Maintainer abuse
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 16 Dec 2014 19:06:24 +1100
In-Reply-To: <alpine.DEB.2.11.1412130016090.16494@nanos>
References: <alpine.DEB.2.11.1412130016090.16494@nanos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-12-13 at 00:24 +0100, Thomas Gleixner wrote:
> I'm really starting to get seriously grumpy about this.
> 
> Everyone is aware that we are in the middle of the merge window. So
> this is definetely NOT the time to send anything else than urgent
> bugfixes or the usual question/reply on something which was discussed
> before.
> 
> I really consider it to be maintainer abuse to have

 ../..

Picking up that thread late ... 

I might have myself been the culprit of that and I don't enforce such
policies on devs on powerpc either, as long as they don't have an
expectation of that stuff being merged before at best the next merge
window.

Especially RFC stuff. People are seeking comments about something or
some approach to a problem, this is clearly not intended for merging and
the comments might not necessarily have to come all from the maintainer,
so I don't see why posting to the list should adhere to a specific
rhythm.

I've certainly myself never taken much attention about when I was
sending a patch, only knew what to expect about when it might end up
being reviewed / merged.

Cheers,
Ben.



