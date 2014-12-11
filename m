Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbaLKF6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 00:58:34 -0500
Received: from ozlabs.org ([103.22.144.67]:48534 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaLKF6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 00:58:33 -0500
Message-ID: <1418277511.24554.3.camel@ellerman.id.au>
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
Date: Thu, 11 Dec 2014 16:58:31 +1100
In-Reply-To: <548856D7.2070706@mvista.com>
References: <54873864.3050606@mvista.com>
	 <1418208784.9279.11.camel@ellerman.id.au> <548856D7.2070706@mvista.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 08:21 -0600, Corey Minyard wrote:
> On 12/10/2014 04:53 AM, Michael Ellerman wrote:
> > Hi Corey,
> >
> > On Tue, 2014-12-09 at 11:59 -0600, Corey Minyard wrote:
> >> Jeremy Kerr (2):
> >>       powerpc/powernv: Add OPAL IPMI interface
> >>       drivers/char/ipmi: Add powernv IPMI driver
> > I created a topic branch for that powerpc patch, but it looks like you didn't
> > merge it?
> 
> No, I missed that.  I've never had to do any serious merging with other
> changes, so I've never had to do this before.  I can fix it if Linus
> wants to wait.  Thanks for the heads up.

OK, no stress.

I think I sent you instructions on how to do it, but feel free to ask if you're
not sure in future.

cheers


