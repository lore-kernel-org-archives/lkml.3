Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbaLKWkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:40:40 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:60326 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759220AbaLKWkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:40:39 -0500
MIME-Version: 1.0
In-Reply-To: <548A1C61.9060905@mvista.com>
References: <54873864.3050606@mvista.com>
	<CA+55aFwYTY1gzRF26cZi2nMm6vDPfEBiSfZmXEUtWa39YjcSRg@mail.gmail.com>
	<548A1C61.9060905@mvista.com>
Date: Thu, 11 Dec 2014 14:40:38 -0800
X-Google-Sender-Auth: hchHSnazFP5l_5StVg21ELJtE4I
Message-ID: <CA+55aFwtWcWjqm05DN5xpemmNtCEkgjx0v_uWsy4c0LWP2FNeA@mail.gmail.com>
Subject: Re: [GIT PULL] ipmi driver updates
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Corey Minyard <cminyard@mvista.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Rex <tony.rex@ericsson.com>,
        Magnus Johansson E <magnus.e.johansson@ericsson.com>,
        =?UTF-8?Q?Per_Fogelstr=C3=B6m?= <per.fogelstrom@ericsson.com>,
        Jeremy Kerr <jk@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>,
        Sanjeev <singhsan@codeaurora.org>, Thomas Renninger <trenn@suse.de>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 2:36 PM, Corey Minyard <cminyard@mvista.com> wrote:
>
>   git://git.code.sf.net/p/openipmi/linux-ipmi openipmi-linux-ipmi for-linus

So I see a "for-linus" tag now, but what's that "openipmi-linux-ipmi"
thing in there?

Also, just in general, please use the normal "git pull-request"
script, which should make these kinds of things clear and error out if
the tag isn't found (at least in current versions of git).

> Also, there was nothing in SubmittingPatches that I could find about
> signing the tags for pull requests.  I can try to write something to add
> there, if you like.  Though someone with more experience might be a
> better candidate.

Hmm. You might want to google around too, because this has come up
before, so there might be explanations lying around on the mailing
lists that just haven't been made into documentation.

                      Linus
