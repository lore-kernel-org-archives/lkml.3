Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaBKQx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:53:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbaBKQxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:53:51 -0500
Date: Tue, 11 Feb 2014 17:53:49 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: dchinner@redhat.com, hannes@cmpxchg.org, akpm@linux-foundation.org,
        glommer@gmail.com, rientjes@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, devel@openvz.org
Subject: Re: [PATCH -mm v15 00/13] kmemcg shrinkers
Message-ID: <20140211165349.GQ11946@dhcp22.suse.cz>
References: <cover.1391624021.git.vdavydov@parallels.com>
 <52FA3E8E.2080601@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FA3E8E.2080601@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11-02-14 19:15:26, Vladimir Davydov wrote:
> Hi Michal, Johannes, David,
> 
> Could you please take a look at this if you have time? Without your
> review, it'll never get committed.

Yes, it is on my todo list. I could barely catch up with discussions on
the previous versions and felt that David was quite concerned about some
high level decisions. I have to check, re-read whether there are still
there.

I am sorry that it takes so long but I am really busy with internal
things recently.
-- 
Michal Hocko
SUSE Labs
