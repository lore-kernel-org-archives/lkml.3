Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbaIZTO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 15:14:27 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52612 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbaIZTOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 15:14:25 -0400
Date: Fri, 26 Sep 2014 12:14:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [git pull] Input updates for 3.17-rc6
Message-ID: <20140926191421.GA14589@core.coreip.homeip.net>
References: <20140926180111.GA3911@core.coreip.homeip.net>
 <CA+55aFzD0Vo2c74_M-k-0Q6kGRd8btYDM34vnYA-UOP6Mko2QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzD0Vo2c74_M-k-0Q6kGRd8btYDM34vnYA-UOP6Mko2QA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 11:19:51AM -0700, Linus Torvalds wrote:
> On Fri, Sep 26, 2014 at 11:01 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >
> > to receive updates for the input subsystem. You will get a small fixup to
> > i8042 adding Asus X450LCP to the nomux list.
> 
> Side note: I'm wondering how painful it would be to just make nomux
> the default.
> 
> I think it's getting to be a legacy issue, since the traditional
> reason for it (afaik) is just having both an external PS/2 port _and_
> a touchpad connnected to the same controller. And even when that
> happens, it seems that as often as not, the bug reports in this area
> have been about the touchpad _not_ working due to us incorrectly
> thinking it's muxed.
> 
> I dunno. Maybe mux mode is used more than I think it is, and it would
> cause tons of problems. But I do find myself wondering whether we'd be
> better off not doing mux by default, and making the DMI check instead
> check for systems that *do* want muxing.
> 
> Hmm? Am I just being crazy?

Not a all. In fact, we've been discussing it recently and I am going to flip
the flag for 3.18. I really think that number users with laptops correctly
implementing MUX and who are also using docking stations with external PS/2
mice) is miniscule (note that we are not talking about users who prefer
external mouse - you don't need MUX for that - we are talking about users who
want native touchpad protocol and also external mouse - at the same time).

Thanks.

-- 
Dmitry
