Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaG1Htb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:49:31 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51947 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaG1HtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:49:22 -0400
Message-ID: <1406533758.5133.238.camel@marge.simpson.net>
Subject: Re: [PATCH 0/2 v4] sched: Rewrite per entity runnable load average
 tracking
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        pjt@google.com, bsegall@google.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, rafael.j.wysocki@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, fengguang.wu@intel.com
Date: Mon, 28 Jul 2014 09:49:18 +0200
In-Reply-To: <20140727193453.GA23367@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
	 <1405835183.6512.37.camel@marge.simpson.net>
	 <20140727193453.GA23367@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-28 at 03:34 +0800, Yuyang Du wrote: 
> Thanks a lot, Mike.
> 
> Ben asked for this test, but actually I don't know how to get pipe-test, still
> not even after google it.

You could write it trivially, it's just pipe ping-pong.  I can send you
a copy of the one I use if you like.  Ingo wrote it way back in the dark
ages, I use it to watch out for fastpath lard accumulation.
> So the result is flat compared to before or a pass?

Yeah, my little box said it was a deep cgroup price noop, but a modest
win for root.  I love minus signs, they work great, though sometimes in
highly mysterious ways :)

-Mike

