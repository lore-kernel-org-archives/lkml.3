Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab3LLMrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:47:48 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:47298 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3LLMrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:47:47 -0500
Date: Thu, 12 Dec 2013 13:47:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Andrzej Pietrasiewicz'" <andrzej.p@samsung.com>,
        linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Ingo Molnar'" <mingo@redhat.com>
Subject: Re: [PATCH v2] kernel/locking: mutex: simplify access to the first
 entry in the wait-list
Message-ID: <20131212124743.GB5806@gmail.com>
References: <1386847772-8918-1-git-send-email-andrzej.p@samsung.com>
 <20131212113511.GG21999@twins.programming.kicks-ass.net>
 <23bd01cef731$fb052680$f10f7380$%park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23bd01cef731$fb052680$f10f7380$%park@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kyungmin Park <kyungmin.park@samsung.com> wrote:

> 
> > -----Original Message-----
> > From: Peter Zijlstra [mailto:peterz@infradead.org]
> > Sent: Thursday, December 12, 2013 8:35 PM
> > To: Andrzej Pietrasiewicz
> > Cc: linux-kernel@vger.kernel.org; Kyungmin Park; Marek Szyprowski; Ingo
> > Molnar
> > Subject: Re: [PATCH v2] kernel/locking: mutex: simplify access to the
> > first entry in the wait-list
> > 
> > On Thu, Dec 12, 2013 at 12:29:32PM +0100, Andrzej Pietrasiewicz wrote:
> > > Use list_first_entry instead of explicitly accessing the first entry
> > > with "head".next. The comment one line above becomes obsolete.
> > >
> > > Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > ---
> > >
> > > v1..v2:
> > >
> > > - corrected the email address in the second Signed-off-by line
> > 
> > Still invalid; the problem is that you appear to have written the patch
> > (you send it and you have first sob).
> 
> 
> > So what is Kyungmin doing in the line? He did not send me your patch.
> 
> Internal review process, and it represents this patch comes from.

That can be expressed via a Reviewed-by line.

Thanks,

	Ingo
