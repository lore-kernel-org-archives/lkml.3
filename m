Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaG1VC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:02:59 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:30282 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaG1VC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:02:58 -0400
Message-ID: <1406581375.2411.52.camel@j-VirtualBox>
Subject: Re: [PATCH -tip/master 3/7] locking/mcs: Remove obsolete comment
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Jul 2014 14:02:55 -0700
In-Reply-To: <20140728185023.GX19379@twins.programming.kicks-ass.net>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
	 <1406524724-17946-3-git-send-email-davidlohr@hp.com>
	 <1406566175.2411.13.camel@j-VirtualBox>
	 <20140728165426.GT19379@twins.programming.kicks-ass.net>
	 <1406569775.2411.48.camel@j-VirtualBox>
	 <20140728185023.GX19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-28 at 20:50 +0200, Peter Zijlstra wrote:
> On Mon, Jul 28, 2014 at 10:49:35AM -0700, Jason Low wrote:
> 
> > So if the function is inlined, perf report would show the contention
> > occurring in the calling function rather than the inlined function. As
> > an example, if we were to convert osq_lock() and mutex_spin_on_owner()
> > to inline, perf would report all the contention from both of those
> > functions occurring in just "__mutex_lock_slowpath()".
> 
> But that's easily fixed on the tool side, right? Dwarf info (as present
> in vmlinux when build with CONFIG_DEBUG_INFO) has all that.

Ok, one more reason to keep it as inline then  :)

