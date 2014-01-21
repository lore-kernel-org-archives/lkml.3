Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaAUGIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 01:08:22 -0500
Received: from mail-gg0-f182.google.com ([209.85.161.182]:60352 "EHLO
	mail-gg0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaAUGIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 01:08:13 -0500
Date: Mon, 20 Jan 2014 22:08:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Kroah-Hartmann <gregkh@linuxfoundation.org>
cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
In-Reply-To: <20140121060428.GA19037@kroah.com>
Message-ID: <alpine.DEB.2.02.1401202204510.21729@chino.kir.corp.google.com>
References: <20140109144757.e95616b4280c049b22743a15@linux-foundation.org> <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com> <20140109161246.57ea590f00ea5b61fdbf5f11@linux-foundation.org> <alpine.DEB.2.02.1401091613560.22649@chino.kir.corp.google.com>
 <20140110221432.GD6963@cmpxchg.org> <alpine.DEB.2.02.1401121404530.20999@chino.kir.corp.google.com> <20140115143449.GN8782@dhcp22.suse.cz> <alpine.DEB.2.02.1401151319580.10727@chino.kir.corp.google.com> <20140116093220.GC28157@dhcp22.suse.cz>
 <alpine.DEB.2.02.1401202155410.21729@chino.kir.corp.google.com> <20140121060428.GA19037@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014, Greg Kroah-Hartmann wrote:

> > The patches getting proposed through -mm for stable boggles my mind
> > sometimes.
> 
> Do you have any objections to patches that I have taken for -stable?  If
> so, please let me know.
> 

You've haven't taken the ones that I outlined in 
http://marc.info/?l=linux-kernel&m=138580717728759, so I'm happy that 
those could be prevented.  I'm identifying another patch here that is 
pending in -mm that obviously violates the stable kernel rules and I don't 
believe it should be annotated in a way that you'll scoop it up later.

The patch in question hasn't been tested by anybody and I don't think you 
want such things to ever be merged into a stable kernel series.
