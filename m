Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809Ab3GETCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 15:02:50 -0400
Received: from gmmr2.centrum.cz ([46.255.227.252]:49696 "EHLO gmmr2.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab3GETCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 15:02:49 -0400
To: =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=5D_memcg=3A_do_not_trap_chargers_with_full_callstack_on_OOM?=
Date: Fri, 05 Jul 2013 21:02:46 +0200
From: "azurIt" <azurit@pobox.sk>
Cc: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>
References: <20130211112240.GC19922@dhcp22.suse.cz>, <20130222092332.4001E4B6@pobox.sk>, <20130606160446.GE24115@dhcp22.suse.cz>, <20130606181633.BCC3E02E@pobox.sk>, <20130607131157.GF8117@dhcp22.suse.cz>, <20130617122134.2E072BA8@pobox.sk>, <20130619132614.GC16457@dhcp22.suse.cz>, <20130622220958.D10567A4@pobox.sk>, <20130624201345.GA21822@cmpxchg.org>, <20130628120613.6D6CAD21@pobox.sk> <20130705181728.GQ17812@cmpxchg.org>
In-Reply-To: <20130705181728.GQ17812@cmpxchg.org>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20130705210246.11D2135A@pobox.sk>
X-Maser: Georgo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I looked at your debug messages but could not find anything that would
>hint at a deadlock.  All tasks are stuck in the refrigerator, so I
>assume you use the freezer cgroup and enabled it somehow?


Yes, i'm really using freezer cgroup BUT i was checking if it's not doing problems - unfortunately, several days passed from that day and now i don't fully remember if i was checking it for both cases (unremoveabled cgroups and these freezed processes holding web server port). I'm 100% sure i was checking it for unremoveable cgroups but not so sure for the other problem (i had to act quickly in that case). Are you sure (from stacks) that freezer cgroup was enabled there?

Btw, what about that other stacks? I mean this file:
http://watchdog.sk/lkml/memcg-bug-7.tar.gz

It was taken while running the kernel with your patch and from cgroup which was under unresolveable OOM (just like my very original problem).

Thank you!


azur
