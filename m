Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030328AbaLLNvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:51:44 -0500
Received: from tex.lwn.net ([70.33.254.29]:40415 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967920AbaLLNvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:51:41 -0500
Date: Fri, 12 Dec 2014 08:51:37 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Corey Minyard <cminyard@mvista.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Rex <tony.rex@ericsson.com>,
        Magnus Johansson E <magnus.e.johansson@ericsson.com>,
        Per =?UTF-8?B?Rm9nZWxzdHI=?= =?UTF-8?B?w7Zt?= 
	<per.fogelstrom@ericsson.com>,
        Jeremy Kerr <jk@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>,
        Sanjeev <singhsan@codeaurora.org>, Thomas Renninger <trenn@suse.de>,
        "openipmi-developer@lists.sourceforge.net\" <openipmi-developer@lists.sourceforge.net>"@lwn.net
Subject: Re: Signed tag docs (was [GIT PULL] ipmi driver updates)
Message-ID: <20141212085137.1275e34e@lwn.net>
In-Reply-To: <548A1C61.9060905@mvista.com>
References: <54873864.3050606@mvista.com>
	<CA+55aFwYTY1gzRF26cZi2nMm6vDPfEBiSfZmXEUtWa39YjcSRg@mail.gmail.com>
	<548A1C61.9060905@mvista.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014 16:36:17 -0600
Corey Minyard <cminyard@mvista.com> wrote:

> Also, there was nothing in SubmittingPatches that I could find about
> signing the tags for pull requests.  I can try to write something to add
> there, if you like.  Though someone with more experience might be a
> better candidate.

I could probably take a stab at this if nobody else is raring to do it.
I just went through the process of figuring it out myself - I think I
*almost* got it right this time around...:)

jon
