Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab3F0Bc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 21:32:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:8873 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab3F0Bcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 21:32:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,948,1363158000"; 
   d="scan'208";a="323144582"
Message-ID: <51CB9631.1030508@intel.com>
Date: Thu, 27 Jun 2013 09:32:33 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v4 1/5] rwsem: check the lock before cpmxchg in down_write_trylock
References: <cover.1372282738.git.tim.c.chen@linux.intel.com> <1372285674.22432.141.camel@schen9-DESK>
In-Reply-To: <1372285674.22432.141.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following line should be added head of commit log on patches 1~4. :)

From: Alex Shi <alex.shi@intel.com>


> Cmpxchg will cause the cacheline bouning when do the value checking,
> that cause scalability issue in a large machine (like a 80 core box).
> 
> So a lock pre-read can relief this contention.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>


-- 
Thanks
    Alex
