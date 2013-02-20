Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213Ab3BTKkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:40:49 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:33662 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759197Ab3BTKkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:40:47 -0500
Date: Wed, 20 Feb 2013 11:40:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        anton@samba.org, hpa@zytor.com, arjan@linux.intel.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        yuanhan.liu@linux.intel.com, dhowells@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 0/4] rwsem: Implement writer lock-stealing
Message-ID: <20130220104043.GB7691@gmail.com>
References: <1360377937-16297-1-git-send-email-walken@google.com>
 <511B9B4F.3060404@intel.com>
 <20130213144932.GA14260@gmail.com>
 <CANN689FJcUZq1wcVZXO+jLOHOeCPnOf5kfYgYVykG6-YLSjj7g@mail.gmail.com>
 <51248E59.2010907@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51248E59.2010907@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alex Shi <alex.shi@intel.com> wrote:

> > Alex, could you go through my patch and see if there is 
> > anything you find objectionable ? (if not about the details, 
> > at least about the general approach of enabling writer lock 
> > stealing on the fast path)
> 
> I did a quick review on the patchset and tested the patches 
> 1~3, and 1~3 plus 4th, my patch plus 4th.
> 
> The patch looks much complicated, and also goes writing slow 
> path to steal locking. My patch looks quite straight and 
> simple.
> 
> This 1~3 patch has very very similar performance effect with 
> mine.
> 
> The highlight patch is the 4th, seems it can provide about ~2% 
> aim7 performance gain(base on both of mine or patches 1~3) on 
> my 4S NHM EX machine.

That speedup would be nice to have.

Thanks,

	Ingo
