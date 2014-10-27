Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbaJ0MHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:07:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:45565 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaJ0MHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:07:39 -0400
Date: Mon, 27 Oct 2014 13:07:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Burke Libbey <burke.libbey@shopify.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sched: reset sched_entity depth on changing parent
Message-ID: <20141027120734.GA3337@twins.programming.kicks-ass.net>
References: <20141024150746.GB25260@burke.local>
 <20141024155805.GF21513@worktop.programming.kicks-ass.net>
 <164441414171122@web11g.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164441414171122@web11g.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 09:18:42PM +0400, Kirill Tkhai wrote:
> I was seeking a places where task_group of a task may change. I can't understand
> how changing of parent's cgroup during fork() applies to a child.

I didn't know we could change cgroup on fork(), I though the idea was
you always inherited your parents cgroup.

How can this be?
