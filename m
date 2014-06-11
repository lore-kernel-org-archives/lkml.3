Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaFKMbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:31:14 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58192 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaFKMbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:31:12 -0400
Date: Wed, 11 Jun 2014 08:31:09 -0400
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] memcg: Allow hard guarantee mode for low limit
 reclaim
Message-ID: <20140611123109.GA17777@htj.dyndns.org>
References: <20140606144421.GE26253@dhcp22.suse.cz>
 <1402066010-25901-1-git-send-email-mhocko@suse.cz>
 <1402066010-25901-2-git-send-email-mhocko@suse.cz>
 <xr934mzt4rwc.fsf@gthelen.mtv.corp.google.com>
 <20140610165756.GG2878@cmpxchg.org>
 <20140611075729.GA4520@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611075729.GA4520@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Jun 11, 2014 at 09:57:29AM +0200, Michal Hocko wrote:
> Is this the kind of symmetry Tejun is asking for and that would make
> change is Nack position? I am still not sure it satisfies his soft

Yes, pretty much.  What primarily bothered me was the soft/hard
guarantees being chosen by a toggle switch while the soft/hard limits
can be configured separately and combined.

> guarantee objections from other email.

I was wondering about the usefulness of "low" itself in isolation and
I still think it'd be less useful than "high", but as there seem to be
use cases which can be served with that and especially as a part of a
consistent control scheme, I have no objection.

"low" definitely requires a notification mechanism tho.

Thanks.

-- 
tejun
