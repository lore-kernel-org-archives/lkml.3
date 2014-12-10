Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbaLJKxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:53:13 -0500
Received: from ozlabs.org ([103.22.144.67]:59007 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbaLJKxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:53:12 -0500
Message-ID: <1418208784.9279.11.camel@ellerman.id.au>
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
Date: Wed, 10 Dec 2014 21:53:04 +1100
In-Reply-To: <54873864.3050606@mvista.com>
References: <54873864.3050606@mvista.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corey,

On Tue, 2014-12-09 at 11:59 -0600, Corey Minyard wrote:
> Jeremy Kerr (2):
>       powerpc/powernv: Add OPAL IPMI interface
>       drivers/char/ipmi: Add powernv IPMI driver

I created a topic branch for that powerpc patch, but it looks like you didn't
merge it?

  https://git.kernel.org/cgit/linux/kernel/git/mpe/linux.git/log/?h=topic/opal-ipmi

The merge conflict between your tree and mine is not all that pretty, though
Linus should be able to work it out. I haven't sent my pull request yet though,
so he'll probably get it when he merges my tree.

The patch in your tree does look correct, so that's OK, but maybe next time we
can both merge the topic branch.

cheers


