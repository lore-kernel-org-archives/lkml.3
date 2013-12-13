Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3LMOIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:08:39 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:38634 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab3LMOIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:08:38 -0500
Date: Fri, 13 Dec 2013 15:08:33 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] kernel/locking: mutex: simplify access to the first
 entry in the wait-list
Message-ID: <20131213140833.GB12379@gmail.com>
References: <1386847772-8918-1-git-send-email-andrzej.p@samsung.com>
 <20131212113511.GG21999@twins.programming.kicks-ass.net>
 <23bd01cef731$fb052680$f10f7380$%park@samsung.com>
 <20131212125203.GI21999@twins.programming.kicks-ass.net>
 <52AAA806.30406@samsung.com>
 <20131213140011.GM21999@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213140011.GM21999@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Dec 13, 2013 at 07:24:06AM +0100, Andrzej Pietrasiewicz wrote:
> > Hello Ingo & Peter,
> > 
> > I added Greg on Cc.
> 
> > For quite a long time I've been sending the same SOB lines to the
> > linux-usb list.
> 
> Then Greg is more forgiving. Doesn't make it right though.

Also, it's easy to not notice, and it has no testable side effects.

Yet if mistakes _are_ noticed like in this case then the inconsistency 
should be fixed, as the SOB chains have specific meaning.

Thanks,

	Ingo
