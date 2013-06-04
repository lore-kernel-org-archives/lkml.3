Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125Ab3FDR5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:57:11 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:46748 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3FDR5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:57:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130604163828.GA9321@dhcp22.suse.cz>
References: <1370254735-13012-1-git-send-email-mhocko@suse.cz>
	<CAKTCnz=CMbhhROPV4iC6_XPuu_8J53ZMTdXtY_bevPjG+B-+mw@mail.gmail.com>
	<20130604163828.GA9321@dhcp22.suse.cz>
Date: Tue, 4 Jun 2013 23:27:05 +0530
Message-ID: <CAKTCnz=MP5iadPJkngJqGMnXSwe9n-xGDEdzuT5Aqoyx0KAYwA@mail.gmail.com>
Subject: Re: [patch v4] Soft limit rework
From: Balbir Singh <bsingharora@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, let me summarize. The primary intention is to get rid of the current
> soft reclaim infrastructure which basically bypasses the standard
> reclaim and tight it directly into shrink_zone code. This also means
> that the soft reclaim doesn't reclaim at priority 0 and that it is
> active also for the targeted (aka limit) reclaim.
>
> Does this help?
>

Yes. What are the limitations of no-priority 0 reclaim? I'll also look
at the patches

Thanks,
Balbir Singh.
