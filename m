Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966006AbaLKXeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 18:34:03 -0500
Received: from ozlabs.org ([103.22.144.67]:55785 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964971AbaLKXeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 18:34:01 -0500
Message-ID: <1418340838.20629.1.camel@ellerman.id.au>
Subject: Re: [GIT PULL] ipmi driver updates
From: Michael Ellerman <mpe@ellerman.id.au>
To: Corey Minyard <cminyard@mvista.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Rex <tony.rex@ericsson.com>,
        Magnus Johansson E <magnus.e.johansson@ericsson.com>,
        Per =?ISO-8859-1?Q?Fogelstr=F6m?= <per.fogelstrom@ericsson.com>,
        Jeremy Kerr <jk@ozlabs.org>, Sanjeev <singhsan@codeaurora.org>,
        Thomas Renninger <trenn@suse.de>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Date: Fri, 12 Dec 2014 10:33:58 +1100
In-Reply-To: <548A21CB.6040200@mvista.com>
References: <54873864.3050606@mvista.com>
		<CA+55aFwYTY1gzRF26cZi2nMm6vDPfEBiSfZmXEUtWa39YjcSRg@mail.gmail.com>
		<548A1C61.9060905@mvista.com>
	 <CA+55aFwtWcWjqm05DN5xpemmNtCEkgjx0v_uWsy4c0LWP2FNeA@mail.gmail.com>
	 <548A21CB.6040200@mvista.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-11 at 16:59 -0600, Corey Minyard wrote:
> On 12/11/2014 04:40 PM, Linus Torvalds wrote:
> > On Thu, Dec 11, 2014 at 2:36 PM, Corey Minyard <cminyard@mvista.com> wrote:
> >>   git://git.code.sf.net/p/openipmi/linux-ipmi openipmi-linux-ipmi for-linus
> > So I see a "for-linus" tag now, but what's that "openipmi-linux-ipmi"
> > thing in there?
> 
> That's a cut and paste error.  I cut from the wrong place, it appears.
> 
> >
> > Also, just in general, please use the normal "git pull-request"
> > script, which should make these kinds of things clear and error out if
> > the tag isn't found (at least in current versions of git).
> >
> >> Also, there was nothing in SubmittingPatches that I could find about
> >> signing the tags for pull requests.  I can try to write something to add
> >> there, if you like.  Though someone with more experience might be a
> >> better candidate.
> > Hmm. You might want to google around too, because this has come up
> > before, so there might be explanations lying around on the mailing
> > lists that just haven't been made into documentation.
> 
> Ok, I'll try to poke around and see what I can find.

There's some here:

https://www.kernel.org/pub/software/scm/git/docs/howto/using-signed-tag-in-pull-request.html

Though it's fairly generic, ie. it's not specifically about the kernel. It
should give you the gist though.

cheers


