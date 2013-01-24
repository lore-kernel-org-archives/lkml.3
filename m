Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3AXXZC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 18:25:02 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50437 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab3AXXY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 18:24:56 -0500
X-AuditID: 9c930179-b7d01ae000004006-2a-5101c2c72795
Date: Fri, 25 Jan 2013 08:24:54 +0900
From: Minchan Kim <minchan@kernel.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Tim Bird <tim.bird@am.sony.com>, Pekka Enberg <penberg@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC/PATCH] scripts/tracing: Add trace_analyze.py tool
Message-ID: <20130124232454.GF22654@blaptop>
References: <1358848018-3679-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <20130123042714.GD2723@blaptop>
 <CALF0-+V6D1Ka9SNyrgRAgTSGLUTp_9y4vYwauSx1qCfU-JOwjA@mail.gmail.com>
 <20130124055042.GE22654@blaptop>
 <CALF0-+VRF=ZK7YH8AkrFM2T4QQ4xz8-MdceSHr4biALxZfGdzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALF0-+VRF=ZK7YH8AkrFM2T4QQ4xz8-MdceSHr4biALxZfGdzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 02:16:35PM -0300, Ezequiel Garcia wrote:
> On Thu, Jan 24, 2013 at 2:50 AM, Minchan Kim <minchan@kernel.org> wrote:
> > On Wed, Jan 23, 2013 at 06:37:56PM -0300, Ezequiel Garcia wrote:
> >
> >>
> >> > 2. Does it support alloc_pages family?
> >> >    kmem event trace already supports it. If it supports, maybe we can replace
> >> >    CONFIG_PAGE_OWNER hack.
> >> >
> >>
> >> Mmm.. no, it doesn't support alloc_pages and friends, for we found
> >> no reason to do it.
> >> However, it sounds like a nice idea, on a first thought.
> >>
> >> I'll review CONFIG_PAGE_OWNER patches and see if I can come up with something.
> >
> > Thanks!
> >
> 
> I'm searching CONFIG_PAGE_OWNER patches, but I could only find this one
> for v2.6.13:
> 
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.13-rc3/2.6.13-rc3-mm1/broken-out/page-owner-tracking-leak-detector.patch
> 
> Is there a more recent one?

Recently, update version is merged into mmotm. Please, see below.
http://git.cmpxchg.org/?p=linux-mmotm.git;a=blob;f=mm/pageowner.c;h=2238bfe282a934ee78ede1856776c577dfb2e630;hb=1e0902949ce18822bf21b0fd96ed7a7c3ac3dee5

> 
> -- 
>     Ezequiel
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
