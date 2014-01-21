Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085AbaAUF6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 00:58:41 -0500
Received: from mail-gg0-f171.google.com ([209.85.161.171]:54027 "EHLO
	mail-gg0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaAUF6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 00:58:32 -0500
Date: Mon, 20 Jan 2014 21:58:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartmann <gregkh@linuxfoundation.org>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
In-Reply-To: <20140116093220.GC28157@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1401202155410.21729@chino.kir.corp.google.com>
References: <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org> <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com> <20140109144757.e95616b4280c049b22743a15@linux-foundation.org> <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com>
 <20140109161246.57ea590f00ea5b61fdbf5f11@linux-foundation.org> <alpine.DEB.2.02.1401091613560.22649@chino.kir.corp.google.com> <20140110221432.GD6963@cmpxchg.org> <alpine.DEB.2.02.1401121404530.20999@chino.kir.corp.google.com> <20140115143449.GN8782@dhcp22.suse.cz>
 <alpine.DEB.2.02.1401151319580.10727@chino.kir.corp.google.com> <20140116093220.GC28157@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Michal Hocko wrote:

> > This is concerning because it's merged in -mm without being tested by Eric 
> > and is marked for stable while violating the stable kernel rules criteria.
> 
> Are you questioning the patch fixes the described issue?
> 
> Please note that the exit_robust_list and PF_EXITING as a culprit has
> been identified by Eric. Of course I would prefer if it was tested by
> anybody who can reproduce it.

You're saying the patch hasn't been tested by anybody and that clearly 
violates the first rule in Documentation/stable_kernel_rules.txt:

 - It must be obviously correct and tested.

Adding Greg to the cc if this should be clarified further.  The patches 
getting proposed through -mm for stable boggles my mind sometimes.
