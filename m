Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab3BMOth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:49:37 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48680 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab3BMOtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:49:36 -0500
Date: Wed, 13 Feb 2013 15:49:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        anton@samba.org, hpa@zytor.com, arjan@linux.intel.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        yuanhan.liu@linux.intel.com, dhowells@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 0/4] rwsem: Implement writer lock-stealing
Message-ID: <20130213144932.GA14260@gmail.com>
References: <1360377937-16297-1-git-send-email-walken@google.com>
 <511B9B4F.3060404@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511B9B4F.3060404@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alex Shi <alex.shi@intel.com> wrote:

> On 02/09/2013 10:45 AM, Michel Lespinasse wrote:
> > This proposal implements writer lock stealing in lib/rwsem.c, just as
> > Alex Shi's earlier proposal did for the simpler lib/rwsem-spinlock.c
> 
> Ops, my patch in tip/urgent is for rwsem. Yuanhan's patch is 
> for rwsem-spinlock.

Your rwsem patch is queued up for v3.9, in the tip:core/locking 
tree:

  3a15e0e0cdda rwsem: Implement writer lock-stealing for better scalability

Michel, mind having a look at that and possibly generate a delta 
patch, if your patch has changes we should apply?

Thanks,

	Ingo
