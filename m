Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3LMOEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:04:33 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:37012 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab3LMOEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:04:32 -0500
Date: Fri, 13 Dec 2013 15:04:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] kernel/locking: mutex: simplify access to the first
 entry in the wait-list
Message-ID: <20131213140426.GA11980@gmail.com>
References: <1386847772-8918-1-git-send-email-andrzej.p@samsung.com>
 <20131212113511.GG21999@twins.programming.kicks-ass.net>
 <23bd01cef731$fb052680$f10f7380$%park@samsung.com>
 <20131212125203.GI21999@twins.programming.kicks-ass.net>
 <52AAA806.30406@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AAA806.30406@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrzej Pietrasiewicz <andrzej.p@samsung.com> wrote:

> Hello Ingo & Peter,
> 
> I added Greg on Cc.
> 
> W dniu 12.12.2013 13:52, Peter Zijlstra pisze:
> >On Thu, Dec 12, 2013 at 09:02:07PM +0900, Kyungmin Park wrote:
> >>
> >>>-----Original Message-----
> >>>From: Peter Zijlstra [mailto:peterz@infradead.org]
> >>>Sent: Thursday, December 12, 2013 8:35 PM
> >>>To: Andrzej Pietrasiewicz
> >>>Cc: linux-kernel@vger.kernel.org; Kyungmin Park; Marek Szyprowski; Ingo
> >>>Molnar
> >>>Subject: Re: [PATCH v2] kernel/locking: mutex: simplify access to the
> >>>first entry in the wait-list
> >>>
> >>>On Thu, Dec 12, 2013 at 12:29:32PM +0100, Andrzej Pietrasiewicz wrote:
> >>>>Use list_first_entry instead of explicitly accessing the first entry
> >>>>with "head".next. The comment one line above becomes obsolete.
> >>>>
> >>>>Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> >>>>Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>>>---
> 
> For quite a long time I've been sending the same SOB lines to the
> linux-usb list.

They can slip through the cracks - but in the past Linus has 
complained about such SOB sequences so it's a real concern.

SOB has a very specific purpose outlined in 
Documentation/SubmittingPatches, please use Reviewed-by or other 
methods of adding credit to others.

Of course if you write a patch and Kyungmin sends me the patch then 
that signoff sequence is completely valid.

Thanks,

	Ingo
