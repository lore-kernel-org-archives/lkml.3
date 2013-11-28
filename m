Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab3K1MA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 07:00:26 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:46744 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604Ab3K1MAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 07:00:22 -0500
Date: Thu, 28 Nov 2013 13:00:18 +0100
From: Michal Hocko <mhocko@suse.cz>
To: William Dauchy <wdauchy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, "Ma, Xindong" <xindong.ma@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, azurIt <azurit@pobox.sk>,
        Sameer Nanda <snanda@chromium.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] Fix race between oom kill and task exit
Message-ID: <20131128120018.GL2761@dhcp22.suse.cz>
References: <3917C05D9F83184EAA45CE249FF1B1DD0253093A@SHSMSX103.ccr.corp.intel.com>
 <20131128063505.GN3556@cmpxchg.org>
 <CAJ75kXZXxCMgf8=pghUWf=W9EKf3Z4nzKKy=CAn+7keVF_DCRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ75kXZXxCMgf8=pghUWf=W9EKf3Z4nzKKy=CAn+7keVF_DCRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing Oleg - the thread started here:
https://lkml.org/lkml/2013/11/28/2]

On Thu 28-11-13 09:41:40, William Dauchy wrote:
[...]
> However, I'm now wondering if this present patch is a replacement of
> Sameer Nanda's patch or if this a complementary patch.

They are both trying to solve the same issue. Neither of them is
optimal unfortunately. Oleg said he would look into this and I have seen
some patches but didn't geto check them.

-- 
Michal Hocko
SUSE Labs
