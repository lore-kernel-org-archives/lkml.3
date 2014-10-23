Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbaJWNGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:06:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821AbaJWNGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:06:33 -0400
Date: Thu, 23 Oct 2014 15:06:31 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the akpm-current tree with the pm
 tree
Message-ID: <20141023130631.GE23011@dhcp22.suse.cz>
References: <20141023140905.3bd78e51@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023140905.3bd78e51@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 23-10-14 14:09:05, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm-current tree got a conflict in
> include/linux/oom.h, kernel/power/process.c and mm/oom_kill.c between
> commit 5695be142e20 ("OOM, PM: OOM killed task shouldn't escape PM
> suspend") from the pm tree and commit e039ae202d34 ("OOM, PM: OOM
> killed task cannot escape PM suspend") from the akpm-current tree.
> 
> I fixed it up (the pm tree version seems to be newer, so I used that)
> and can carry the fix as necessary (no action is required).

Yes that is correct. I thought Andrew has dropped the previous version
of the patch from his tree. Rafael has merged his in the meantime.

Thanks!
-- 
Michal Hocko
SUSE Labs
