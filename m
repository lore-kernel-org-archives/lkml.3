Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3KAIVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 04:21:52 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:61757 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab3KAIVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 04:21:50 -0400
Date: Fri, 1 Nov 2013 09:21:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 0/4] per anon_vma lock and turn anon_vma rwsem lock to
 rwlock_t
Message-ID: <20131101082146.GA27021@gmail.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20131101080135.GB25547@gmail.com>
 <20131101081159.GB12829@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101081159.GB12829@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:

> > Btw., another _really_ interesting comparison would be against 
> > the latest rwsem patches. Mind doing such a comparison?
> 
> Sure. Where can I get it? Are they on some git tree?

I've Cc:-ed Tim Chen who might be able to point you to the latest 
version.

The last on-lkml submission was in this thread:

  Subject: [PATCH v8 0/9] rwsem performance optimizations

Thanks,

	Ingo
