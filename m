Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3CUQTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:19:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab3CUQTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:19:37 -0400
Date: Thu, 21 Mar 2013 17:17:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, cgroups@vger.kernel.org
Subject: Re: [PATCH cgroup/for-3.10] cgroup: make cgroup_mutex outer to
	threadgroup_lock
Message-ID: <20130321161727.GA21760@redhat.com>
References: <20130307191242.GA18265@redhat.com> <20130307193820.GB3209@htj.dyndns.org> <513A9A67.60909@huawei.com> <20130309032936.GT14556@mtj.dyndns.org> <513AE918.7020704@huawei.com> <20130319220246.GR3042@htj.dyndns.org> <514909A0.4030808@huawei.com> <20130320150351.GW3042@htj.dyndns.org> <20130320183523.GA29365@redhat.com> <CAOS58YPxGXt+iq1GZ4hryqm1Z_p+r7eRRC7ruUDDd=LQrWtAxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YPxGXt+iq1GZ4hryqm1Z_p+r7eRRC7ruUDDd=LQrWtAxg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20, Tejun Heo wrote:
>
> On Wed, Mar 20, 2013 at 11:35 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > then we need "do not abuse ->cred_guard_mutex in threadgroup_lock()"
> > acked by you and Li. Please let me know if I should resend it.
>
> Yeah, we want that one regardless of this one. Please feel free to add
> my Acked-by (if I hadn't acked already, that is).

Yeah, you have already acked it, thanks

> How should your
> patch be routed? Through -mm?

Well, this is the only method I know ;) So I am resending it to Andrew
with your acks apllied.

Oleg.

