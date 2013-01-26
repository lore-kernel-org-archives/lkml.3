Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3AZMFP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 07:05:15 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:48081 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3AZMFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 07:05:13 -0500
Date: Sat, 26 Jan 2013 13:05:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, walken@google.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, knoel@redhat.com, chegu_vinod@hp.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@redhat.com
Subject: Re: [PATCH -v4 0/5] x86,smp: make ticket spinlock proportional
 backoff w/ auto tuning
Message-ID: <20130126120509.GD13445@gmail.com>
References: <20130125140553.060b8ced@annuminas.surriel.com>
 <1359184867.5835.85.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359184867.5835.85.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <bitbucket@online.de> wrote:

> On Fri, 2013-01-25 at 14:05 -0500, Rik van Riel wrote:
> 
> > The performance issue observed with AIM7 is still a mystery.
> 
> Hm.  AIM7 mystery _may_ be the same crud I see on a 4 node 40 
> core box. Stock scheduler knobs are too preempt happy, produce 
> unstable results. I twiddle them as below to stabilize 
> results.
> 
> I'm testing a load balancing series from Alex Shi with AIM7 
> and whatnot, added your series on top of it and retested.  
> What I see is improvement.

Since we want both series that's good news, agreed?

Thanks,

	Ingo
