Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab3HMQFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:05:16 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:58225 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758824Ab3HMQE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:04:28 -0400
Date: Tue, 13 Aug 2013 18:04:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vince Weaver <vince@deater.net>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        peterz@infradead.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk
 executable
Message-ID: <20130813160424.GC5280@gmail.com>
References: <20130805081641.GA24808@gmail.com>
 <20130805082320.GA9562@infradead.org>
 <20130805083132.GE26746@gmail.com>
 <20130805083434.GA20606@infradead.org>
 <20130805090857.GA26940@gmail.com>
 <20130806061932.GA20485@infradead.org>
 <20130812181956.GB19405@gmail.com>
 <alpine.DEB.2.02.1308121521170.25956@pianoman.cluster.toy>
 <20130813104821.GB2170@gmail.com>
 <alpine.DEB.2.02.1308130955360.4537@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308130955360.4537@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vince@deater.net> wrote:

> On Tue, 13 Aug 2013, Ingo Molnar wrote:
> > * Vince Weaver <vince@deater.net> wrote:
> 
> > In the past you used to only test your library once the -stable kernel was 
> > released - has this changed recently by any chance? I remember that in one 
> > particular case I got a regression bugreport from you essentially on the 
> > day of a -stable release.
> > 
> > If you tested -rc2 or so that would give us a much larger window to 
> > fix any breakages that affect your library. (I'm not even asking for 
> > linux-next testing.)
> 
> I wasn't aware that the Linux "no-ABI breakage guarantee" only applied 
> to people who ran -rc kernels.

It obviously does not, and nowhere did I claim the opposite.

> I've spent a lot of time enhancing trinity and writing my own perf 
> syscall fuzzer just to try to keep on top of ABI breaks as per your 
> rules and they still slip in and they still don't get reverted.

Your fuzzing effort is much appreciated, but please don't mix this up with 
the other ABI bugs you were talking about:

> > > > I've had perf ABI changes break programs I maintain at least three 
> > > > times in the last 2 kernel releases.

We can only fix regressions after they get reported.

Thanks,

	Ingo
