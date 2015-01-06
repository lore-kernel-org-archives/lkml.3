Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbbAFXU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 18:20:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55456 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbAFXU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 18:20:27 -0500
Date: Wed, 7 Jan 2015 00:20:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Mark Seaborn <mseaborn@chromium.org>,
        kernel list <linux-kernel@vger.kernel.org>, luto@amacapital.net
Subject: Re: DRAM unreliable under specific access patern
Message-ID: <20150106232025.GA32569@amd>
References: <CAL82V5NN8U4PyiSjLxgpTrgsgkbM7rRCbVF5P-HHyEqphLOy+g@mail.gmail.com>
 <20141224220818.GA17655@amd>
 <20150105192329.5f32c155@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105192329.5f32c155@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2015-01-05 19:23:29, One Thousand Gnomes wrote:
> > In the meantime, I created test that actually uses physical memory,
> > 8MB apart, as described in some footnote. It is attached. It should
> > work, but it needs boot with specific config options and specific
> > kernel parameters.
> 
> Why not just use hugepages. You know the alignment guarantees for 1GB
> pages and that means you don't even need to be root
> 
> In fact - should we be disabling 1GB huge page support by default at this
> point, at least on non ECC boxes ?

Actually, I could not get my test code to run; and as code from

https://github.com/mseaborn/rowhammer-test

reproduces issue for me, I stopped trying. I could not get it to
damage memory of other process than itself (but that should be
possible), I guess that's next thing to try.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
