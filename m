Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab3CTShd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:37:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab3CTShb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:37:31 -0400
Date: Wed, 20 Mar 2013 19:35:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, cgroups@vger.kernel.org
Subject: Re: [PATCH cgroup/for-3.10] cgroup: make cgroup_mutex outer to
	threadgroup_lock
Message-ID: <20130320183523.GA29365@redhat.com>
References: <20130307180139.GD29601@htj.dyndns.org> <20130307180332.GE29601@htj.dyndns.org> <20130307191242.GA18265@redhat.com> <20130307193820.GB3209@htj.dyndns.org> <513A9A67.60909@huawei.com> <20130309032936.GT14556@mtj.dyndns.org> <513AE918.7020704@huawei.com> <20130319220246.GR3042@htj.dyndns.org> <514909A0.4030808@huawei.com> <20130320150351.GW3042@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130320150351.GW3042@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20, Tejun Heo wrote:
>
> So, let's leave the locking in cgroup alone.  I like
> cgroup_mutex to be the outer one.

OK... but sorry, I am a bit confused.

then we need "do not abuse ->cred_guard_mutex in threadgroup_lock()"
acked by you and Li. Please let me know if I should resend it.

Oleg.

