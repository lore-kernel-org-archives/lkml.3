Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaIWNFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:05:39 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42256 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaIWNFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:05:37 -0400
Date: Tue, 23 Sep 2014 09:05:33 -0400
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [GIT PULL] cgroup fixes for v3.17-rc6
Message-ID: <20140923130533.GA14905@mtj.dyndns.org>
References: <20140923063353.GK11740@mtj.dyndns.org>
 <54211707.8090604@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54211707.8090604@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 02:45:27PM +0800, Zefan Li wrote:
> On 2014/9/23 14:33, Tejun Heo wrote:
> > Hello, Linus.
> > 
> > One late fix for cgroup.  I was waiting for another set of fixes for a
> > long-standing obscure cpuset bug but am not sure whether they'll be
> > ready before v3.17 release.  This one is a simple fix for a mutex
> > unlock balance bug, which is detected by coccinelle and probably won't
> > trigger in the wild, introduced during this devel cycle.
> > 
> 
> It was introduced in 3.14, and it was detected by my eyes, not coccinelle. ;)

Hah, I got it completely mixed up with another patch in my head.  Will
post an updated pull request.  My apologies.

Thanks.

-- 
tejun
