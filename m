Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3IZCkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:40:33 -0400
Received: from smtprelay0152.hostedemail.com ([216.40.44.152]:39890 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751283Ab3IZCkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:40:32 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2525:2553:2561:2564:2682:2685:2693:2828:2829:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3
X-HE-Tag: dress90_213f78171ff33
X-Filterd-Recvd-Size: 2715
Message-ID: <1380163226.17366.54.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Add test for #defines of ARCH_HAS_<foo>
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
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
Date: Wed, 25 Sep 2013 19:40:26 -0700
In-Reply-To: <20130925193250.7747b0e3.akpm@linux-foundation.org>
References: <1380125886-10341-1-git-send-email-fweisbec@gmail.com>
	 <1380125886-10341-8-git-send-email-fweisbec@gmail.com>
	 <CA+55aFzPArB0dotWZz8dLTPVM4MMT75NAb5_DVcPrNuvWu4QUA@mail.gmail.com>
	 <20130925172121.00c23e416398139f4615943c@linux-foundation.org>
	 <1380156027.17366.39.camel@joe-AO722>
	 <CA+55aFycQ9XJvEOsiM3txHL5bjUc8CeKWJNR_H+MiicaddB42Q@mail.gmail.com>
	 <1380160854.17366.49.camel@joe-AO722>
	 <20130925193250.7747b0e3.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-25 at 19:32 -0700, Andrew Morton wrote:
> On Wed, 25 Sep 2013 19:00:54 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > +# Use of __ARCH_HAS_<FOO> or ARCH_HAVE_<BAR> is wrong.
> > +		if ($line =~ /\+\s*#\s*define\s+((?:__)?ARCH_(?:HAS|HAVE)\w*)\b/) {
> > +			ERROR("DEFINE_ARCH_HAS",
> > +			      "#define of '$1' is wrong - use Kconfig variables or standard guards instead\n" . $herecurr);
> > +		}
> > +
> 
> Perhaps we can provide people with a bit more help than that. 
> http://www.kernelhub.org/?msg=334759&p=2 would suit (gad, google
> updates fast!) or copy-n-paste into Documentation/wherever and refer to
> that?
> 

Maybe the fancy lkml.kernel.org link:

http://lkml.kernel.org/r/CA+55aFycQ9XJvEOsiM3txHL5bjUc8CeKWJNR_H+MiicaddB42Q@mail.gmail.com

as that might be more long-term stable.

Will kernel.org ever store all the lkml emails so it
doesn't have to reference outside links?


