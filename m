Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3GBMmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 08:42:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab3GBMmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 08:42:11 -0400
Date: Tue, 2 Jul 2013 14:42:08 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Aaron Staley <aaron@picloud.com>,
        containers@lists.linux-foundation.org, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: PROBLEM: Processes writing large files in memory-limited LXC
 container are killed by OOM
Message-ID: <20130702124208.GF16815@dhcp22.suse.cz>
References: <CAMcjixYa-mjo5TrxmtBkr0MOf+8r_iSeW5MF4c8nJKdp5m+RPA@mail.gmail.com>
 <20130701180101.GA5460@ac100>
 <20130701184503.GG17812@cmpxchg.org>
 <20130701190222.GA10367@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701190222.GA10367@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 01-07-13 14:02:22, Serge Hallyn wrote:
> Quoting Johannes Weiner (hannes@cmpxchg.org):
[...]
> > OOM with too many dirty pages', included in 3.6+.
> 
> Is anyone actively working on the long term solution?

Patches for memcg dirty pages accounted were posted quite some time ago.
I plan to look at the at some point but I am rather busy with other
stuff right now. That would be just a first step though. Then we need to
hook into dirty pages throttling and make it memcg aware which sounds
like a bigger challenge.

-- 
Michal Hocko
SUSE Labs
