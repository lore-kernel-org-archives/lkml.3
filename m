Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab3E1Uhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:37:32 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:15211 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab3E1Uhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:37:31 -0400
Message-ID: <1369773466.4188.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/4] ipc/sem.c: Bug fixes, regression fixes, v3
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 May 2013 13:37:46 -0700
In-Reply-To: <51A38257.2020804@colorfullife.com>
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
	 <1369601453.2259.15.camel@buesod1.americas.hpqcorp.net>
	 <51A38257.2020804@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*sigh* it seems that the email this morning wasn't sent, resending...

On Mon, 2013-05-27 at 17:57 +0200, Manfred Spraul wrote:
> Hi Davidlohr,
> 
> On 05/26/2013 10:50 PM, Davidlohr Bueso wrote:
> >
> > In lack of getting my swingbench DSS environment back, I ran these
> > changes against the semop-multi program on my laptop. For 256 threads,
> > with Manfred's patchset the ops/sec suffers around -7.3%.
> 
> Could you also check the performance of only patch#1?
> I fear that it might be slower than all 4 together.

Performance wise, patch 1 actually doesn't make any difference with what
was already upstream.

> 
> With regards to semop-multi:
> Is this the tool?
> http://marc.info/?l=linux-kernel&m=136208613626892&q=p3

Yep.

Thanks,
Davidlohr

