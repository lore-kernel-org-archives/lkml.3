Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836Ab3GWSa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:30:28 -0400
Received: from mail-ye0-f172.google.com ([209.85.213.172]:38577 "EHLO
	mail-ye0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933513Ab3GWSaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:30:23 -0400
Date: Tue, 23 Jul 2013 14:30:18 -0400
From: Tejun Heo <tj@kernel.org>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [RFC PATCH 1/2] devices cgroup: allow can_attach() if ns_capable
Message-ID: <20130723183018.GF21100@mtj.dyndns.org>
References: <20130723181606.GA6342@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723181606.GA6342@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 01:16:06PM -0500, Serge Hallyn wrote:
> We allow a task to change its own devices cgroup, or to change other tasks'
> cgroups if it has CAP_SYS_ADMIN.
> 
> Also allow task A to change task B's cgroup if task A has CAP_SYS_ADMIN
> with respect to task B - meaning A is root in the same userns, or A
> created B's userns.

As discussed multpile times, cgroup isn't gonna support delegating
cgroup management directly into containers, so this doesn't really
jive with where we're heading.

Thanks.

-- 
tejun
