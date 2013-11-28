Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab3K1LzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:55:19 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:62584 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab3K1LzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:55:04 -0500
Date: Thu, 28 Nov 2013 12:54:58 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, Greg Thelen <gthelen@google.com>,
        Glauber Costa <glommer@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Joern Engel <joern@logfs.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: user defined OOM policies
Message-ID: <20131128115458.GK2761@dhcp22.suse.cz>
References: <20131119131400.GC20655@dhcp22.suse.cz>
 <20131119134007.GD20655@dhcp22.suse.cz>
 <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com>
 <20131120152251.GA18809@dhcp22.suse.cz>
 <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20-11-13 19:33:00, David Rientjes wrote:
[...]
> Agreed, and I think the big downside of doing it with the loadable module 
> suggestion is that you can't implement such a wide variety of different 
> policies in modules.  Each of our users who own a memcg tree on our 
> systems may want to have their own policy and they can't load a module at 
> runtime or ship with the kernel.

But those users care about their local (memcg) OOM, don't they? So they
do not need any module and all they want is to get a notification.
-- 
Michal Hocko
SUSE Labs
