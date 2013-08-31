Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab3HaGlQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 02:41:16 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37621 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab3HaGlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 02:41:14 -0400
Date: Sat, 31 Aug 2013 08:41:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the tip tree
Message-ID: <20130831064110.GB28562@gmail.com>
References: <20130819142633.82fb06bfa3bc0276fb09cbea@canb.auug.org.au>
 <20130819065817.GB23742@gmail.com>
 <20130820005234.GX19750@two.firstfloor.org>
 <20130820064209.GB9518@gmail.com>
 <20130830185546.69a289c2bef2173cc1ededf4@canb.auug.org.au>
 <20130830204224.GD16724@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830204224.GD16724@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> > > I've seen this pattern of deficient changelogs a dozen 
> > > times in your patches this year alone ...
> > 
> > Ping?
> 
> I've re-sent the patch already last week.

hpa was on vacation, if he doesn't pick it up I'll apply it.

> Some perf patches are also pending, there just seems to be a long 
> backlog.
> 
> http://permalink.gmane.org/gmane.linux.kernel/1548787 
> http://permalink.gmane.org/gmane.linux.kernel/1548788 
> http://permalink.gmane.org/gmane.linux.kernel/1548790 
> http://permalink.gmane.org/gmane.linux.kernel/1548791

There's no perf patches backlog. The ones you link to here were delayed 
because you (again) ignored maintainer review feedback:

  https://lkml.org/lkml/2013/8/30/370

Not sure you noticed, but kernel subsystem maintainers are not your 
repeat-everything-a-thousand-times patch submission QA machinery.

I have no problems explaining kernel contribution basics to newbies, but 
as a long-time kernel contributor you are expected to submit patch series 
whose quality is proportional to the amount of time you have already spent 
submitting patches. I.e. the longer the time you actively spent sending 
patches, the higher quality your patch series should become.

Instead what I see from you are the same problems over and over again: 
sloppy patches, ignored review feedback.

So to protect other people's higher quality patch flows maintainers that 
deal with you frequently often have to put your faulty submissions to the 
tail of their TODO list, until you show more reliable patterns of 
behavior. I will eventually have to stop taking patches from you 
permanently, if your abuse of review feedback continues.

Instead of complaining and blaming the maintainer you should increase the 
quality of your patch submissions instead.

Thanks,

	Ingo
