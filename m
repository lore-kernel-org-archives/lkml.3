Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab3F0P7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:59:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:25885 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab3F0P7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:59:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,953,1363158000"; 
   d="scan'208";a="360554067"
Subject: Re: [PATCH v4 1/5] rwsem: check the lock before cpmxchg in
 down_write_trylock
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <51CB9631.1030508@intel.com>
References: <cover.1372282738.git.tim.c.chen@linux.intel.com>
	 <1372285674.22432.141.camel@schen9-DESK>  <51CB9631.1030508@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jun 2013 08:59:18 -0700
Message-ID: <1372348758.22432.153.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 09:32 +0800, Alex Shi wrote:
> The following line should be added head of commit log on patches 1~4. :)
> 
> From: Alex Shi <alex.shi@intel.com>
> 
> 
> > Cmpxchg will cause the cacheline bouning when do the value checking,
> > that cause scalability issue in a large machine (like a 80 core box).
> > 
> > So a lock pre-read can relief this contention.
> > 
> > Signed-off-by: Alex Shi <alex.shi@intel.com>
> 
> 

Okay.  Will add the From line in addition to Signed off line on next
update.

Tim

