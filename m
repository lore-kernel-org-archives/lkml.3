Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3DWIba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 04:31:30 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58553 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3DWIbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 04:31:18 -0400
X-AuditID: 9c930179-b7b5bae0000069d1-aa-517646d45a69
Date: Tue, 23 Apr 2013 17:31:16 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "Low, Jason" <jason.low2@hp.com>
Subject: Re: [PATCH v2 0/6] correct load_balance()
Message-ID: <20130423083116.GA3390@lge.com>
References: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20130422080135.GA19454@lge.com>
 <1366632078.4443.15.camel@laptop>
 <1366661227.3788.10.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366661227.3788.10.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 01:07:07PM -0700, Davidlohr Bueso wrote:
> On Mon, 2013-04-22 at 14:01 +0200, Peter Zijlstra wrote:
> > On Mon, 2013-04-22 at 17:01 +0900, Joonsoo Kim wrote:
> > 
> > > Hello, Ingo and Peter.
> > > 
> > > Just ping for this patchset.
> > 
> > The patches look fine -- except a few cosmetic changes. I'm fine with
> > Ingo taking them now and merging a 7/6 patch that clears up the
> > cosmetic issues or you can repost with them taken care of.
> > 
> > I'll leave that up to you and Ingo.
> > 
> > Otherwise:
> > 
> > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> On behalf of Jason who has been testing this patchset:
> 
> Tested-by: Jason Low <jason.low2@hp.com>

Hello, Jason and Davidlohr.
Thanks for testing!

> 
> Thanks,
> Jason & Davidlohr
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
