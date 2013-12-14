Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3LNT1n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:27:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab3LNT1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:27:02 -0500
Date: Sat, 14 Dec 2013 09:26:54 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Ingo Molnar'" <mingo@redhat.com>
Subject: Re: [PATCH v2] kernel/locking: mutex: simplify access to the first
 entry in the wait-list
Message-ID: <20131214172654.GE22520@kroah.com>
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
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 03:00:11PM +0100, Peter Zijlstra wrote:
> On Fri, Dec 13, 2013 at 07:24:06AM +0100, Andrzej Pietrasiewicz wrote:
> > Hello Ingo & Peter,
> > 
> > I added Greg on Cc.
> 
> > For quite a long time I've been sending the same SOB lines to the
> > linux-usb list.
> 
> Then Greg is more forgiving. Doesn't make it right though.

I usually make sure the one sending me the patch is the "last" on the
chain, if not, that's a mistake on my part when I take the patch, sorry.

greg k-h
