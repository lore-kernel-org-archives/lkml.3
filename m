Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab3LMOA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:00:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43316 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab3LMOA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:00:27 -0500
Date: Fri, 13 Dec 2013 15:00:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] kernel/locking: mutex: simplify access to the first
 entry in the wait-list
Message-ID: <20131213140011.GM21999@twins.programming.kicks-ass.net>
References: <1386847772-8918-1-git-send-email-andrzej.p@samsung.com>
 <20131212113511.GG21999@twins.programming.kicks-ass.net>
 <23bd01cef731$fb052680$f10f7380$%park@samsung.com>
 <20131212125203.GI21999@twins.programming.kicks-ass.net>
 <52AAA806.30406@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AAA806.30406@samsung.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 07:24:06AM +0100, Andrzej Pietrasiewicz wrote:
> Hello Ingo & Peter,
> 
> I added Greg on Cc.

> For quite a long time I've been sending the same SOB lines to the
> linux-usb list.

Then Greg is more forgiving. Doesn't make it right though.
