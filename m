Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbaIRPQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:16:45 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:61128 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756339AbaIRPQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:16:44 -0400
Date: Thu, 18 Sep 2014 11:16:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wang Nan <wangnan0@huawei.com>, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] cgroup/kmemleak: add kmemleak_free() for cgroup
 deallocations.
Message-ID: <20140918111634.1bb56716@gandalf.local.home>
In-Reply-To: <20140918141639.GA17230@cmpxchg.org>
References: <1411004285-42101-1-git-send-email-wangnan0@huawei.com>
	<20140918141639.GA17230@cmpxchg.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014 10:16:39 -0400
Johannes Weiner <hannes@cmpxchg.org> wrote:
 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Should this go into -stable?  I'm inclined to say no, this has been
> busted since Steve's other kmemleak fix since 2011, and that change
> also didn't go into -stable.

It only breaks kmem tests, and since nobody noticed recently, I don't
think it needs to go into stable.

On the other hand, it's a very non intrusive fix that I highly doubt
will cause other regressions, so it may not be bad to add a stable tag
to it.

-- Steve
