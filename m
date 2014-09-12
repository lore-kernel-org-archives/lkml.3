Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaILOu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:50:58 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:41337 "EHLO
	homiemail-a61.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944AbaILOu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:50:56 -0400
Message-ID: <1410533379.2166.14.camel@linux-t7sj.site>
Subject: Re: [PATCH 8/9] locktorture: Support rwsems
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, mingo@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Sep 2014 07:49:39 -0700
In-Reply-To: <20140912073729.GK346@worktop.programming.kicks-ass.net>
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
	 <1410496890.2166.11.camel@linux-t7sj.site>
	 <20140912073729.GK346@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 09:37 +0200, Peter Zijlstra wrote:
> On Thu, Sep 11, 2014 at 09:41:30PM -0700, Davidlohr Bueso wrote:
> > We can easily do so with our new reader lock support. Just an arbitrary
> > design default: readers have higher (5x) critical region latencies than
> > writers: 50 ms and 10 ms, respectively.
> > 
> 
> Nice, could you copy/paste this into a rwlock test as well?

Indeed, if folks like what the see in this patchset then adding more
locks is pretty trivial.


