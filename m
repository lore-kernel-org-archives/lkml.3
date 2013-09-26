Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3IZCcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:32:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3IZCcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:32:41 -0400
Date: Wed, 25 Sep 2013 19:32:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] checkpatch: Add test for #defines of ARCH_HAS_<foo>
Message-Id: <20130925193250.7747b0e3.akpm@linux-foundation.org>
In-Reply-To: <1380160854.17366.49.camel@joe-AO722>
References: <1380125886-10341-1-git-send-email-fweisbec@gmail.com>
	<1380125886-10341-8-git-send-email-fweisbec@gmail.com>
	<CA+55aFzPArB0dotWZz8dLTPVM4MMT75NAb5_DVcPrNuvWu4QUA@mail.gmail.com>
	<20130925172121.00c23e416398139f4615943c@linux-foundation.org>
	<1380156027.17366.39.camel@joe-AO722>
	<CA+55aFycQ9XJvEOsiM3txHL5bjUc8CeKWJNR_H+MiicaddB42Q@mail.gmail.com>
	<1380160854.17366.49.camel@joe-AO722>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013 19:00:54 -0700 Joe Perches <joe@perches.com> wrote:

> +# Use of __ARCH_HAS_<FOO> or ARCH_HAVE_<BAR> is wrong.
> +		if ($line =~ /\+\s*#\s*define\s+((?:__)?ARCH_(?:HAS|HAVE)\w*)\b/) {
> +			ERROR("DEFINE_ARCH_HAS",
> +			      "#define of '$1' is wrong - use Kconfig variables or standard guards instead\n" . $herecurr);
> +		}
> +

Perhaps we can provide people with a bit more help than that. 
http://www.kernelhub.org/?msg=334759&p=2 would suit (gad, google
updates fast!) or copy-n-paste into Documentation/wherever and refer to
that?

