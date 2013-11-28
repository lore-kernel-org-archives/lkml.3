Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252Ab3K1R5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 12:57:50 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:44861 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758240Ab3K1R5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 12:57:48 -0500
Date: Thu, 28 Nov 2013 18:57:11 +0100
From: Vladimir Murzin <murzin.v@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: William Dauchy <wdauchy@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Ma, Xindong" <xindong.ma@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, azurIt <azurit@pobox.sk>,
        Sameer Nanda <snanda@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        dserrg@gmail.com
Subject: Re: [PATCH] Fix race between oom kill and task exit
Message-ID: <20131128175708.GA1875@hp530>
References: <3917C05D9F83184EAA45CE249FF1B1DD0253093A@SHSMSX103.ccr.corp.intel.com>
 <20131128063505.GN3556@cmpxchg.org>
 <CAJ75kXZXxCMgf8=pghUWf=W9EKf3Z4nzKKy=CAn+7keVF_DCRA@mail.gmail.com>
 <20131128120018.GL2761@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20131128120018.GL2761@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 01:00:18PM +0100, Michal Hocko wrote:
> [CCing Oleg - the thread started here:
> https://lkml.org/lkml/2013/11/28/2]
> 
> On Thu 28-11-13 09:41:40, William Dauchy wrote:
> [...]
> > However, I'm now wondering if this present patch is a replacement of
> > Sameer Nanda's patch or if this a complementary patch.
> 
> They are both trying to solve the same issue. Neither of them is
> optimal unfortunately. Oleg said he would look into this and I have seen
> some patches but didn't geto check them.

CCing Sergey - he reported and proposed the patch for the similar issue.

Vladimir

> 
> -- 
> Michal Hocko
> SUSE Labs
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
