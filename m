Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab3CTSm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:42:29 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:55581 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3CTSm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:42:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130320183523.GA29365@redhat.com>
References: <20130307180139.GD29601@htj.dyndns.org>
	<20130307180332.GE29601@htj.dyndns.org>
	<20130307191242.GA18265@redhat.com>
	<20130307193820.GB3209@htj.dyndns.org>
	<513A9A67.60909@huawei.com>
	<20130309032936.GT14556@mtj.dyndns.org>
	<513AE918.7020704@huawei.com>
	<20130319220246.GR3042@htj.dyndns.org>
	<514909A0.4030808@huawei.com>
	<20130320150351.GW3042@htj.dyndns.org>
	<20130320183523.GA29365@redhat.com>
Date: Wed, 20 Mar 2013 11:42:25 -0700
X-Google-Sender-Auth: fIdBDEmG5TGrc3ruASB6dq5PBnM
Message-ID: <CAOS58YPxGXt+iq1GZ4hryqm1Z_p+r7eRRC7ruUDDd=LQrWtAxg@mail.gmail.com>
Subject: Re: [PATCH cgroup/for-3.10] cgroup: make cgroup_mutex outer to threadgroup_lock
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, cgroups@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:35 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> then we need "do not abuse ->cred_guard_mutex in threadgroup_lock()"
> acked by you and Li. Please let me know if I should resend it.

Yeah, we want that one regardless of this one. Please feel free to add
my Acked-by (if I hadn't acked already, that is). How should your
patch be routed? Through -mm?

Thanks.

-- 
tejun
