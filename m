Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3LBOMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:12:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab3LBOMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:12:07 -0500
Date: Mon, 2 Dec 2013 15:12:03 +0100
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
Message-ID: <20131202141203.GA31402@redhat.com>
References: <3917C05D9F83184EAA45CE249FF1B1DD0253093A@SHSMSX103.ccr.corp.intel.com> <20131128063505.GN3556@cmpxchg.org> <CAJ75kXZXxCMgf8=pghUWf=W9EKf3Z4nzKKy=CAn+7keVF_DCRA@mail.gmail.com> <20131128120018.GL2761@dhcp22.suse.cz> <20131128183830.GD20740@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128183830.GD20740@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Oleg Nesterov wrote:
>
> On 11/28, Michal Hocko wrote:
> >
> > They are both trying to solve the same issue. Neither of them is
> > optimal unfortunately.
>
> yes, but this one doesn't look right.
>
> > Oleg said he would look into this and I have seen
> > some patches but didn't geto check them.
>
> Only preparations so far.

OK, I am going to send the initial fixes today. This means (I hope)
that we do not need this or Sameer's "[PATCH] mm, oom: Fix race when
selecting process to kill".

Oleg.

