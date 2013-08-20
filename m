Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab3HTQQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:16:33 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54586 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751345Ab3HTQQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:16:31 -0400
Date: Tue, 20 Aug 2013 17:15:51 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: P J P <ppandit@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: About perf,arm -- oops in validate_event
Message-ID: <20130820161550.GA21383@arm.com>
References: <alpine.LFD.2.03.1308201522230.15482@erqung.pbz>
 <CAHkRjk76V-RyJbm4mSNt6DLpLDv_wqcuag5Z_hSTcrcdUi=6jg@mail.gmail.com>
 <alpine.DEB.2.10.1308201039570.14233@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1308201039570.14233@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 03:42:56PM +0100, Vince Weaver wrote:
> On Tue, 20 Aug 2013, Catalin Marinas wrote:
> 
> > On 20 August 2013 11:03, P J P <ppandit@redhat.com> wrote:
> > >  -> https://lkml.org/lkml/2013/8/7/259
> > >
> > > I wanted to confirm if this above fix should also go into ARM64 build Or is
> > > ARM64 platform not vulnerable?
> > 
> > It is and I'll push patches to mainline (Will is preparing them).
> 
> You'll probably also want the equivalent of 
>     d9f966357b14e356dbd83b8f4a197a287ab4ff83
> as well since arch/arm64/kernel/perf_event.c
> has the same overflow in armpmu_map_event that is fixed in the mentioned
> commit.

Yes, I'm pushing both.

Thanks.

-- 
Catalin
