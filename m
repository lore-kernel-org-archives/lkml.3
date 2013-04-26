Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3DZG7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:59:31 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:33717 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab3DZG7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:59:30 -0400
Date: Fri, 26 Apr 2013 08:59:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Basic perf PMU support for Haswell v11
Message-ID: <20130426065926.GA31487@gmail.com>
References: <1366484783-15613-1-git-send-email-andi@firstfloor.org>
 <20130426065503.GA31197@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426065503.GA31197@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> You say it's barebones, yet it does not work :-( How well was this 
> patch-set tested on non-Haswell hardware, which makes up 99.99% of our 
> installed base?
> 
> In particular, after applying your patches, 'perf top' stopped working 
> on an Intel testbox of mine:

The other problem I noticed was stylistic: when I applied your patches for 
testing even Git complained about their cleanliness ...

To quote from Documentation/SubmittingPatches:

  4) Style check your changes.

  Check your patch for basic style violations, details of which can be
  found in Documentation/CodingStyle.  Failure to do so simply wastes
  the reviewers time and will get your patch rejected, probably
  without even being read.

  At a minimum you should check your patches with the patch style
  checker prior to submission (scripts/checkpatch.pl).  You should
  be able to justify all violations that remain in your patch.

Please make your patches less sloppy!

Thanks,

	Ingo
