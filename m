Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab3BZN0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 08:26:10 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:54690 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab3BZN0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 08:26:09 -0500
MIME-Version: 1.0
In-Reply-To: <512C8D84.7090707@huawei.com>
References: <512B01FA.5020506@huawei.com>
	<512B020D.9040504@huawei.com>
	<20130226022703.GA13837@htj.dyndns.org>
	<512C8D84.7090707@huawei.com>
Date: Tue, 26 Feb 2013 05:26:08 -0800
X-Google-Sender-Auth: RIa5Rqea3XTvFwVvIe5J5EK7LM8
Message-ID: <CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 26, 2013 at 2:25 AM, Li Zefan <lizefan@huawei.com> wrote:
> Sure we can. We'll have to allocate cgrp->name in cgroup_remount() and
> cgroup_init(), and free cgrp->name in cgroup_kill_sb(). It looks to me
> the current version is a bit simpler.

Can't we just set it to constant "/"?  Root cgroup init is a separate
path anyway.

Thanks.

-- 
tejun
