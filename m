Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaIEWqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:46:00 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:41184 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbaIEWp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:45:59 -0400
Date: Sat, 6 Sep 2014 07:45:54 +0900
From: Tejun Heo <tj@kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140905224554.GD15723@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <20140905140815.GA10455@mtj.dyndns.org>
 <CAM_iQpUJONZ7UWTzJoqsbYfHsp5HnRVR-mhpP_kvR3AUafELqQ@mail.gmail.com>
 <20140905180040.GC12991@mtj.dyndns.org>
 <CAM_iQpUbGTxrbJZ_ztf+QUvFowsivQ-jvPCSi7kmth7nstPvaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUbGTxrbJZ_ztf+QUvFowsivQ-jvPCSi7kmth7nstPvaA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 05, 2014 at 11:12:24AM -0700, Cong Wang wrote:
> > Rafael, can you please help?
> 
> Rafael is known not responsive at least for this topic. :)

:(

> > Shouldn't the primary goal of the comment be explaining why we need
> > TIF_MEMDIE check there at all anyway?  The deadlock possiblity is not
> > very obvious.
> 
> The changelog is not long enough?? ;-) I hate to copy+paste changelog
> into comments, changelog is essentially necessary for people to understand
> kernel code (at least networking) , so I don't think we have to move it
> into comments in this case.

It doesn't have to be the same text but the current comment is
basically content-less.  e.g. it can just say "OOM killer may get
stuck trying to kill a cgroup frozen task" and actualy provide
information on what condition the conditional tries to address.

Thanks.

-- 
tejun
