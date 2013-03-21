Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab3CUPGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:06:16 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:56008 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab3CUPGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:06:14 -0400
Date: Thu, 21 Mar 2013 08:05:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        CAI Qian <caiqian@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        lizefan@huawei.com
Subject: Re: [GIT PULL tip/core/urgent] Fix for hlist_entry_safe() regression
Message-ID: <20130321150552.GQ3637@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130314205307.GA27968@linux.vnet.ibm.com>
 <20130321142254.GA2992@linux.vnet.ibm.com>
 <CA+55aFzk3XZSX6WWsZAyUqYO5qvZWN5dTvMr2==So25h9V79ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzk3XZSX6WWsZAyUqYO5qvZWN5dTvMr2==So25h9V79ew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032115-3620-0000-0000-000001B77AB1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 07:42:03AM -0700, Linus Torvalds wrote:
> On Thu, Mar 21, 2013 at 7:22 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > [Reposting with corrected subject line.]
> >
> > Hello, Ingo,
> >
> > This series contains a single commit that fixes a regression in
> > hlist_entry_safe().  ..
> 
> You do realize that I already merged this a week ago directly? (Merge
> commit f4846e52c517)

I do now!  I must confess that I didn't think to check mainline.
Please accept my apologies for the noise.

							Thanx, Paul

