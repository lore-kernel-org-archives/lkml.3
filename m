Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbaGQWnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 18:43:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:44235 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbaGQWnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 18:43:18 -0400
Date: Fri, 18 Jul 2014 00:43:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Joe Perches <joe@perches.com>
cc: Richard Weinberger <richard@nod.at>, akpm@linux-foundation.org,
        apw@canonical.com, tytso@mit.edu, dwalter@google.com, bp@suse.de,
        neilb@suse.de, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
In-Reply-To: <1405612283.12363.10.camel@joe-AO725>
Message-ID: <alpine.DEB.2.10.1407180039510.24854@nanos>
References: <1405611268-12463-1-git-send-email-richard@nod.at> <1405612283.12363.10.camel@joe-AO725>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Joe Perches wrote:

> On Thu, 2014-07-17 at 17:34 +0200, Richard Weinberger wrote:
> > checkpatch.pl is a nice tool to find issues in patches.
> 
> grep is a similar tool, just less automated.
> 
> > Sadly this tool gets more and more abused by various people to create
> > style cleanups for source files within the kernel.
> > In order to deal with that bad habit let's remove the --file option
> > and bring checkpatch.pl back to its original purpose.
> 
> Any tool can be misused.
> 
> diff -urN /dev/null $file | ./scripts/checkpatch.pl -
> 
> does the same thing as --file so I don't see any real
> fundamental difference.

There is a fundamental difference:

Coming up with the above requires actual brain involvement.

./scripts/checkpatch.pl -f

not so much.

So, for Richards patch:

Acked-and-heartely-welcomed-by: Thomas Gleixner <tglx@linutronix.de>

