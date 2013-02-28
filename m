Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab3B1PbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:31:14 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:52050 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab3B1PbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 10:31:12 -0500
Subject: Re: [RFC PATCH] sched: wakeup buddy
From: Namhyung Kim <namhyung@kernel.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
In-Reply-To: <1362046013.4460.195.camel@marge.simpson.net>
References: <512EFB4B.5040204@linux.vnet.ibm.com>
	 <87hakwssc9.fsf@sejong.aot.lge.com>
	 <1362046013.4460.195.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Mar 2013 00:31:05 +0900
Message-ID: <1362065465.1758.15.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-02-28 (목), 11:06 +0100, Mike Galbraith:
> On Thu, 2013-02-28 at 18:25 +0900, Namhyung Kim wrote:
> 
> > Not sure if it should require bidirectional relationship.  Looks like
> > just for benchmarks.  Isn't there a one-way relationship that could get
> > a benefit from this?  I don't know ;-)
> 
> ??  Meaningful relationships are bare minimum bidirectional, how can you
> describe one connection and have it remain meaningful?  I love "her" is
> unlikely to lead to anything meaningful if "she" doesn't know you exist.

Maybe I misunderstood something.  I was thinking about typical
cooperation models like manager-worker, producer-consumer or pipeline
and thought that they are usually one-way relationship in terms of the
wakeup.

Thanks,
Namhyung


