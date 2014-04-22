Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbaDVQ1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:27:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756828AbaDVQ1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:27:13 -0400
Date: Tue, 22 Apr 2014 18:27:07 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Daniel Borkmann <dborkman@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Rohit Jnagal <jnagal@google.com>,
        Brandon Philips <brandon.philips@coreos.com>
Subject: Re: [PATCH v2 cgroup/for-3.16] cgroup: add documentation about
 unified hierarchy
Message-ID: <20140422162707.GR29311@dhcp22.suse.cz>
References: <20140414220917.GD1863@htj.dyndns.org>
 <20140416145248.GD1257@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416145248.GD1257@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16-04-14 10:52:48, Tejun Heo wrote:
[....]
> +The memory controller currently doesn't have a way to control what
> +happens between internal tasks and child cgroups and the behavior is
> +not clearly defined. 

I am not sure I understand this. Could you be more specific what exactly
is not clearly defined?

Thanks
-- 
Michal Hocko
SUSE Labs
