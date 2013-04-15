Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab3DOBCx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 21:02:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39613 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab3DOBCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 21:02:52 -0400
Date: Sun, 14 Apr 2013 20:02:44 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, vgoyal@redhat.com,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 2/4] move cgroupfs_root to include/linux/cgroup.h
Message-ID: <20130415010244.GC8408@sergelap>
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
 <1365808259-31073-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365808259-31073-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> While controllers shouldn't be accessing cgroupfs_root directly, it
> being hidden inside kern/cgroup.c makes somethings pretty silly.  This
> makes routing hierarchy-wide settings which need to be visible to
> controllers cumbersome.
> 
> We're gonna add another hierarchy-wide setting which needs to be
> accessed from controllers.  Move cgroupfs_root and its flags to the
> header file so that we can access root settings with inline helpers.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
