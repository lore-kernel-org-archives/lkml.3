Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab3BRRID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:08:03 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:57856 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab3BRRIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:08:01 -0500
Date: Mon, 18 Feb 2013 09:07:56 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/2] Revert "cgroup: fix cgroup_path() vs rename() race"
Message-ID: <20130218170756.GC17414@htj.dyndns.org>
References: <51205684.5040407@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51205684.5040407@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Sun, Feb 17, 2013 at 12:03:16PM +0800, Li Zefan wrote:
> This reverts commit 299772fab304ab3a36b22b5d28ed81f9408972e7

I didn't push 299772 to 3.8.  I forgot about it for a couple weeks and
then it felt too late and was planning to push it through for-3.9.
I'm just gonna drop for-3.8-fixes and cherr-pick the following two
commits into for-3.9.

 * 7ccff5e0e9 ("cgroup: fix exit() vs rmdir() race")
 * 0844ab1e68 ("cpuset: fix cpuset_print_task_mems_allowed() vs rename() race")

Thanks.

-- 
tejun
