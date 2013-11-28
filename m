Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399Ab3K1SiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 13:38:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab3K1SiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 13:38:01 -0500
Date: Thu, 28 Nov 2013 19:38:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
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
        Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH] Fix race between oom kill and task exit
Message-ID: <20131128183830.GD20740@redhat.com>
References: <3917C05D9F83184EAA45CE249FF1B1DD0253093A@SHSMSX103.ccr.corp.intel.com> <20131128063505.GN3556@cmpxchg.org> <CAJ75kXZXxCMgf8=pghUWf=W9EKf3Z4nzKKy=CAn+7keVF_DCRA@mail.gmail.com> <20131128120018.GL2761@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128120018.GL2761@dhcp22.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Michal Hocko wrote:
>
> They are both trying to solve the same issue. Neither of them is
> optimal unfortunately.

yes, but this one doesn't look right.

> Oleg said he would look into this and I have seen
> some patches but didn't geto check them.

Only preparations so far.

Oleg.

