Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab3EGRpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 13:45:01 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:33310 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab3EGRpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 13:45:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130507173231.GL18614@n2100.arm.linux.org.uk>
References: <1367942534-2934003-1-git-send-email-arnd@arndb.de>
	<CA+55aFwMXmJ9V+3o62ELm-0NT1DaUCTvidmAhJSXzQcTMfJygA@mail.gmail.com>
	<20130507173231.GL18614@n2100.arm.linux.org.uk>
Date: Tue, 7 May 2013 10:44:59 -0700
X-Google-Sender-Auth: AAfrVNJcPvz8qwGBIoGtHpYPCKY
Message-ID: <CA+55aFwW1TyWwJs1CQxnj08Qe-A+eFD20B4fVVT8Te=6eBcTqw@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: Third batch of arm-soc changes for 3.10
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 10:32 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>
> So I don't think that asking people to play games with delays between
> consecutive messages is going to work all that well.

Actually, since this has happened before (a lot) with patch series,
I'm pretty sure it helps.

I used to get re-ordered patches from Andrew all the time, and asked
him to try to avoid it (yes, he also numbers them well, but alpine -
which is what I used for batching email when there are lots of patches
- had this annoying habit of ignoring the "[PATCH n]" part when asked
to sort subject alphabetically). These days, he seems to put a delay
of a second between his patch-bombings these days, and that has almost
entirely solved the problem (so in a series of over a hundred, I
seldom get any renumbering at all, and fixing it up manually if it
happens is much easier now).

But yes, it probably depends very much on where things get sent from,
and in particular if you have some slow SMTP server in one of the
hops. So it's possible that the reason I don't see it with Andrew any
more is simply due to issues like that.

                  Linus
