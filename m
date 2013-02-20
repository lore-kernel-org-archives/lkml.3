Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935466Ab3BTOLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:11:12 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44726
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935211Ab3BTOLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:11:10 -0500
Date: Wed, 20 Feb 2013 11:10:57 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fix for v3.9
Message-ID: <20130220141056.GC1915@ghostprotocols.net>
References: <20130219141642.GA12928@gmail.com>
 <CA+55aFwR=p9YL0UKo3E_e1PRZvga8TeWLbqQGvwTzKGaazHrvA@mail.gmail.com>
 <20130220091758.GB18213@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220091758.GB18213@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 20, 2013 at 10:17:58AM +0100, Ingo Molnar escreveu:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Tue, Feb 19, 2013 at 6:16 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > > Please pull the latest perf-urgent-for-linus git tree from:

> > >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus
> > >    HEAD: e97cbe3edf7d88aad4c21dd3de124d9f9d039881 perf/hwbp: Fix cleanup in case of kzalloc() failure

> > > Leftover fix from the v3.8 cycle.

> > This was already in the other (big) perf pull, as commit
> > 02e176af92f3

> Oops, sorry - Arnaldo picked up the fix too and I never noticed the
> overlap.

Yeah, I need to have a perf/kcore, for kernel bits that are not tied to
userspace ones.

- Arnaldo
