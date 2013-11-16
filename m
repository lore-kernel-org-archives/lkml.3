Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3KPLNH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 06:13:07 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58010 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab3KPLM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 06:12:58 -0500
Date: Sat, 16 Nov 2013 12:12:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org, Frank Becker <fb@alien8.de>
Subject: Re: [GIT PULL] A minor amd64_edac fix for 3.13
Message-ID: <20131116111227.GD18306@pd.tnic>
References: <20131110122638.GA17775@pd.tnic>
 <CAADWXX_FdW4vGn8N4TA_GcNBrwuqeH_=qxmK2J7K7kfAWztxPA@mail.gmail.com>
 <20131116100649.GB18306@pd.tnic>
 <CA+55aFxHO9035t=CiNTRX1XK5KSxzh8HfZ3Kaspsm6yfs2O=8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFxHO9035t=CiNTRX1XK5KSxzh8HfZ3Kaspsm6yfs2O=8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 02:50:49AM -0800, Linus Torvalds wrote:
> As far as I can tell, only that one email had gotten caught by the
> spam filter. So it may be something in the body of the email itself,
> although I don't really see what that could be either..

Right.

> It happens occasionally, although it doors seem to happen much more to
> certain particular people than to others.

AFAIR, it had happened once before with a pull request a couple of
kernel releases back. Oh well, I will start sending the pull requests
from suse.de as their range is statically allocated and this should take
care of the dynamic IP range issues.

> The most common reason seems to be that your email provide is
> associated with spam, sometimes just because of a shared ISP.

Sure, it is one: https://www.hetzner.de/

> It is hard to tell with gmail, since it probably uses heuristics very
> much like spamassassin, but doesn't make the internal scores available
> (to avoid gaming them, I'm sure). So there are likely multiple small
> triggers that combine, rather than one single reason. With "possibly
> bad ISP" probably just being one of them..

Right, I'm adding Frank who takes care of it, just so he's aware.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
