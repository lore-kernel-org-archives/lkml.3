Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3GEK2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:28:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37675 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab3GEK2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:28:54 -0400
Date: Fri, 5 Jul 2013 12:28:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched, __wake_up_sync_key: Fix nr_exclusive tasks which
 lead to WF_SYNC clearing
Message-ID: <20130705102850.GN23916@twins.programming.kicks-ass.net>
References: <512421372963700@web25f.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512421372963700@web25f.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 10:48:20PM +0400, Kirill Tkhai wrote:
> The only one task can replace waker.

Fair enough.. thanks!
