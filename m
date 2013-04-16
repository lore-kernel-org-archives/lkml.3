Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050Ab3DPRLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:11:03 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38070 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856Ab3DPRLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:11:01 -0400
Date: Tue, 16 Apr 2013 10:10:56 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        bsingharora@gmail.com, dhaval.giani@gmail.com,
        Kay Sievers <kay.sievers@vrfy.org>, jpoimboe@redhat.com,
        berrange@redhat.com, lpoetter@redhat.com, workman-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: cgroup: status-quo and userland efforts
Message-ID: <20130416171056.GA2874@mtj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <516D333D.4040703@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516D333D.4040703@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Tue, Apr 16, 2013 at 07:17:17PM +0800, Li Zefan wrote:
...
> > hot-unplug).  It currently transfers all its tasks to the nearest
> > ancestor with executing resources, which is an irreversible process
> > which would affect all other co-mounted controllers.  We probably want
> > it to just take on the masks of the ancestor until its own executing
> > resources become online again, and the new behavior should be gated
> > behind a switch (Li, can you please look into this?).
> > 
> 
> Sure, I'll be working on sane hierarchy behavior for cpuset.

Great, it'd be great if you can share how it's gonna be done once the
basic design gets settled before full implementation.

Thanks a lot!

-- 
tejun
