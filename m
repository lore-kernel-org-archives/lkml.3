Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934577AbaFTPI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:08:56 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:48585 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756016AbaFTPD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:03:27 -0400
X-Yandex-Uniq: 3d045346-ea7e-446a-b55d-9500513b310d
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Fri, 20 Jun 2014 19:03:18 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] perf trace pagefaults
Message-ID: <20140620150318.GK15620@stfomichev-desktop.yandex.net>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
 <20140620132105.GE31524@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620132105.GE31524@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just to clarify here, those slides came from slides I made and in turn
> the whole idea about pagefaults tracing I got from the trace prototype
> that Thomas Gleixner implemented in his 'trace'  utility, described
> here:
> 
>   Announcing a new utility: 'trace'
>   http://lwn.net/Articles/415728/
> 
> The comments section has lots of interesting ideas, some you may find
> interesting to implement :-)
> 
> There is a branch in my tree with the branch tglx did his work on:
> 
> https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/log/?h=tmp.perf/trace2
Wow, thanks, I tried to search lkml for any presence of
patches/discussion about these slides, but couldn't find anything, thanks for
pointing it out.

I really like 'blocking/preempted' indication and of course I miss
pointers decoding.

Did anyone really think about decoding pointers and how we can
implement it (like dumping them upon entering a syscall and then
using inside the perf trace?)?
