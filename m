Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaIDOof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:44:35 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:59415
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbaIDOod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:44:33 -0400
Date: Thu, 4 Sep 2014 16:44:29 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 0/3] ns, procfs: pid conversion between ns and
 showing pidns hierarchy
Message-ID: <20140904144429.GA13407@mail.hallyn.com>
References: <1409740200-26461-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409740200-26461-1-git-send-email-chenhanxiao@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chen Hanxiao (chenhanxiao@cn.fujitsu.com):
> This series will expose pid inside containers
> via procfs.
> Also show the hierarchy of pid namespcae.
> Then we could know how pid looks inside a container
> and their ns relationships.
> 
> Chen Hanxiao (3):
>   procfs: check uniq proc_dir_entry subdir name
>   procfs: show hierarchy of pid namespace
>   /proc/pid/status: show all sets of pid according to ns
> 
>  fs/proc/Kconfig           |   6 ++
>  fs/proc/Makefile          |   1 +
>  fs/proc/array.c           |  17 +++++
>  fs/proc/generic.c         |  15 +++++
>  fs/proc/pidns_hierarchy.c | 161 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/proc_fs.h   |   3 +
>  6 files changed, 203 insertions(+)
>  create mode 100644 fs/proc/pidns_hierarchy.c

Thanks, Chen.  I'm sorry I won't have a chance to review this week, but
hope to do next week.
