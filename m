Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbaDKJCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:02:20 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:28538 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbaDKJCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:02:17 -0400
Message-ID: <5347AF43.9000108@huawei.com>
Date: Fri, 11 Apr 2014 17:00:51 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, <gregkh@linuxfoundation.org>,
        <rlove@rlove.org>, <containers@lists.linux-foundation.org>,
        <kay@vrfy.org>, <linux-kernel@vger.kernel.org>,
        <lennart@poettering.net>, <cgroups@vger.kernel.org>,
        <eparis@parisplace.org>, <john@johnmccutchan.com>
Subject: Re: [PATCH 3/3] cgroup: implement cgroup.subtree_populated for the
 default hierarchy
References: <1397056052-2829-1-git-send-email-tj@kernel.org> <1397056052-2829-4-git-send-email-tj@kernel.org> <20140410030855.GA29658@mail.hallyn.com> <20140410130831.GA25308@htj.dyndns.org> <20140410140424.GA4481@sergelap> <20140410141957.GE25308@htj.dyndns.org>
In-Reply-To: <20140410141957.GE25308@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah, you're right, cgroup_task_migrate() sets CGRP_RELEASABLE
> explicitly.  I was confused because put_css_set_locked() sets
> CGRP_RELEASABLE only if @taskexit is set.  Will drop that part from
> the description.
> 

"If the notify_on_release flag is enabled (1) in a cgroup, then
whenever the last task in the cgroup leaves (exits or attaches to
some other cgroup) and the last child cgroup of that cgroup
is removed, then the kernel runs the command specified by the contents
of the "release_agent" file"

says cgroups.txt. :)

