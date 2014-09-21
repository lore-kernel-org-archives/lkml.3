Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaIUEhd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 00:37:33 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34334 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaIUEhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 00:37:32 -0400
Message-ID: <1411274247.4081.4.camel@marge.simpson.net>
Subject: Re: [PATCH 6/7] sched: Delete rq::skip_clock_update == -1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>
Date: Sun, 21 Sep 2014 06:37:27 +0200
In-Reply-To: <20140920190139.GW2832@worktop.localdomain>
References: <20140920165116.16299.1381.stgit@localhost>
	 <20140920165146.16299.20907.stgit@localhost>
	 <20140920190139.GW2832@worktop.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-09-20 at 21:01 +0200, Peter Zijlstra wrote: 
> On Sat, Sep 20, 2014 at 08:51:46PM +0400, Kirill Tkhai wrote:
> > From: Kirill Tkhai <ktkhai@parallels.com>
> > 
> > Idle class task is always queued, so we can safely remove "-1" case here.
> 
> Tag you're it :-)
> 
> https://lkml.org/lkml/2014/4/8/295

Maybe it should be given the too annoying to live treatment.  Saving
fastpath cycles is great, corner cases less so.

-Mike

