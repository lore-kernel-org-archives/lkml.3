Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3JGJJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 05:09:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57864 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3JGJJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 05:09:06 -0400
Date: Mon, 7 Oct 2013 11:08:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131007090856.GS26785@twins.programming.kicks-ass.net>
References: <20131005234430.GA22485@localhost>
 <20131007085533.GZ3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007085533.GZ3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 10:55:33AM +0200, Peter Zijlstra wrote:
> Wu, do you use the same compiler version for all the builds that crash
> like this (I'm assuming the other email was this same commit)? Does a
> different compiler make things work again?

OK, so in a further email you say you use gcc-4.8.1 (which is actually
newer than the one I used for most of the work although I do have it and
tried it iirc).


