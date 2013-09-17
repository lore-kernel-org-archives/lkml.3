Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3IQU5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:57:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab3IQU5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:57:53 -0400
Date: Tue, 17 Sep 2013 13:57:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>,
        Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH v5] Soft limit rework
Message-Id: <20130917135751.962fd27b03a576ac2a926ee8@linux-foundation.org>
In-Reply-To: <20130917195615.GC856@cmpxchg.org>
References: <20130819163512.GB712@cmpxchg.org>
	<20130820091414.GC31552@dhcp22.suse.cz>
	<20130820141339.GA31419@cmpxchg.org>
	<20130822105856.GA21529@dhcp22.suse.cz>
	<20130903161550.GA856@cmpxchg.org>
	<20130904163823.GA30851@dhcp22.suse.cz>
	<20130906192311.GE856@cmpxchg.org>
	<20130913144953.GA23857@dhcp22.suse.cz>
	<20130913161709.GV856@cmpxchg.org>
	<20130916164405.GG3674@dhcp22.suse.cz>
	<20130917195615.GC856@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Sep 2013 15:56:15 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> > Anyway. Your wording that nothing should be done about the soft reclaim
> > seems to be quite clear though. If this position is really firm then go
> > ahead and NACK the series _explicitly_ so that Andrew or you can send a
> > revert request to Linus. I would really like to not waste a lot of time
> > on testing right now when it wouldn't lead to anything.
> 
> Nacked-by: Johannes Weiner <hannes@cmpxchg.org>

OK, I queued a bunch of reverts for when Linus gets back to his desk.

It's all my fault for getting distracted for a week (in the middle of
the dang merge window) and not noticing that we haven't yet settled on
a direction.  Sorry bout that.

