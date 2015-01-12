Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbbALRfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:35:20 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33533 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbbALRfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:35:18 -0500
Date: Mon, 12 Jan 2015 18:35:15 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH -v3 5/5] oom, PM: make OOM detection in the freezer path
 raceless
Message-ID: <20150112173515.GF4877@dhcp22.suse.cz>
References: <1420801555-22659-1-git-send-email-mhocko@suse.cz>
 <1420801555-22659-6-git-send-email-mhocko@suse.cz>
 <20150110194322.GE25319@htj.dyndns.org>
 <20150112161011.GE4877@dhcp22.suse.cz>
 <20150112172251.GB22156@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112172251.GB22156@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 12-01-15 12:22:51, Tejun Heo wrote:
> On Mon, Jan 12, 2015 at 05:10:11PM +0100, Michal Hocko wrote:
> > Yes I had it this way but it didn't work out because thaw_kernel_threads
> > is not called on the resume because it is only used as a fail
> > path when kernel threads freezing fails. I would rather keep the
> 
> Ooh, that's kinda asymmetric.
> 
> > enabling/disabling points as we had them. This is less risky IMHO.
> 
> Okay, please feel free to add
> 
>  Acked-by: Tejun Heo <tj@kernel.org>

Thanks!
-- 
Michal Hocko
SUSE Labs
