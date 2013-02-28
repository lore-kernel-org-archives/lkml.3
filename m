Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3B1KHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:07:06 -0500
Received: from mout.gmx.net ([212.227.15.15]:62808 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab3B1KHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:07:02 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+W7kR2PqeWzo0HJ9hvabGNdSlMojPUPRX+olGhYx
	uUzJToXy8XBlo1
Message-ID: <1362046013.4460.195.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] sched: wakeup buddy
From: Mike Galbraith <efault@gmx.de>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Date: Thu, 28 Feb 2013 11:06:53 +0100
In-Reply-To: <87hakwssc9.fsf@sejong.aot.lge.com>
References: <512EFB4B.5040204@linux.vnet.ibm.com>
	 <87hakwssc9.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 18:25 +0900, Namhyung Kim wrote:

> Not sure if it should require bidirectional relationship.  Looks like
> just for benchmarks.  Isn't there a one-way relationship that could get
> a benefit from this?  I don't know ;-)

??  Meaningful relationships are bare minimum bidirectional, how can you
describe one connection and have it remain meaningful?  I love "her" is
unlikely to lead to anything meaningful if "she" doesn't know you exist.

-Mike

