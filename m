Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaLOLPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:15:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:43112 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaLOLPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:15:48 -0500
Date: Mon, 15 Dec 2014 12:15:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Maintainer abuse
In-Reply-To: <20141213135231.5684cf9d@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.11.1412151211520.16494@nanos>
References: <alpine.DEB.2.11.1412130016090.16494@nanos> <20141212234336.GA28451@pd.tnic> <20141213135231.5684cf9d@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2014, One Thousand Gnomes wrote:
> Is it the year for a Google summer of code project or similar to turn
> patchwork into a proper patch management tool (one that collects the
> patches, provides a good maintainer interface, tells people automatically
> that their patches are queued, deletes repeats, gives them status urls
> they can give to managers or check, and also has the right bits
> maintainer side to actually do stuff like send out "your patch set no
> longer merges, please update" emails, and tell the maintainer if it
> merges, the coding style important bits, etc and with buttons for "merge
> me"

If that works with command line tools which nicely integrate into
e-mail, that might be something useful. If it involves browser clicky
interfaces, then at least for me not so much.
 
> It could then be integrated into git (if only so we can have a "git lost"
> command to block annoying sources)
> 
> 2. Is X86 moving at a rate which needs some additional maintainers to
> "maintain" the pending queue during merge windows and the like, and get
> stuff into order for the maintainers proper ?

It usually works quite well. Just getting large patchsets sent in the
merge window or just right before it is a pain.

Thanks,

	tglx
