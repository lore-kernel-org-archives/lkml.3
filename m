Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab3DOCuP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:50:15 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:10027 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3DOCuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:50:13 -0400
Message-ID: <516B6AAB.8010507@huawei.com>
Date: Mon, 15 Apr 2013 10:49:15 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <mhocko@suse.cz>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <glommer@parallels.com>,
        <vgoyal@redhat.com>
Subject: Re: [PATCH 3/4] cgroup: introduce sane_behavior mount option
References: <1365808259-31073-1-git-send-email-tj@kernel.org> <1365808259-31073-4-git-send-email-tj@kernel.org>
In-Reply-To: <1365808259-31073-4-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	{
> +		.name = "cgroup.sane_behavior",
> +		.flags = CFTYPE_ONLY_ON_ROOT,
> +		.read_seq_string = cgroup_sane_behavior_show,
> +		.mode = S_IRUGO,
> +	},

We don't have to set .mode explicitly.

