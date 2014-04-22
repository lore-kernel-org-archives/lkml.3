Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaDVSS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:18:59 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:30254 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaDVSS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:18:56 -0400
Message-ID: <1398190732.2473.9.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 2/4] ipc/shm.c: check for overflows of shm_tot
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, gthelen@google.com,
        aswin@hp.com, linux-mm@kvack.org
Date: Tue, 22 Apr 2014 11:18:52 -0700
In-Reply-To: <1398090397-2397-3-git-send-email-manfred@colorfullife.com>
References: <1398090397-2397-1-git-send-email-manfred@colorfullife.com>
	 <1398090397-2397-2-git-send-email-manfred@colorfullife.com>
	 <1398090397-2397-3-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-21 at 16:26 +0200, Manfred Spraul wrote:
> shm_tot counts the total number of pages used by shm segments.
> 
> If SHMALL is ULONG_MAX (or nearly ULONG_MAX), then the number
> can overflow.  Subsequent calls to shmctl(,SHM_INFO,) would return
> wrong values for shm_tot.
> 
> The patch adds a detection for overflows.
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

Acked-by: Davidlohr Bueso <davidlohr@hp.com>

