Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab3DOOqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:46:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab3DOOqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:46:37 -0400
Date: Mon, 15 Apr 2013 07:46:33 -0700
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, glommer@parallels.com, vgoyal@redhat.com
Subject: Re: [PATCHSET] cgroup, memcg: introduce sane_behavior mount option
Message-ID: <20130415144633.GD13662@dhcp22.suse.cz>
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
 <20130415031754.GG3050@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130415031754.GG3050@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 14-04-13 20:17:54, Tejun Heo wrote:
> On Fri, Apr 12, 2013 at 04:10:55PM -0700, Tejun Heo wrote:
> > To make progress, those behaviors need to go but we can't simply drop
> > or change the crazies as those are directly visible to userland.  This
> > patchset implements a mount option - sane_behavior - which turns on
> > new saner behaviors, so that we can keep providing the old behaviors
> > while and after transitioning to saner ones.
> 
> Applied 1-3 to cgroup/for-3.10.  Michal, I left the last memcg one
> out.  Please let me know how you wanna route it.

You can route it via your tree as it seems like the simplest way.

Thanks!
-- 
Michal Hocko
SUSE Labs
