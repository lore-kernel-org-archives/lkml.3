Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3FZJNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:13:44 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:50005 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3FZJNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:13:40 -0400
Message-ID: <51CAB091.1030405@huawei.com>
Date: Wed, 26 Jun 2013 17:12:49 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <trinity@vger.kernel.org>
Subject: Re: [PATCH cgroup/for-3.11] cgroup: grab cgroup_mutex in drop_parsed_module_refcounts()
References: <51C9D17B.5090208@oracle.com> <20130626010454.GD30407@mtj.dyndns.org> <20130626010521.GE30407@mtj.dyndns.org>
In-Reply-To: <20130626010521.GE30407@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/26 9:05, Tejun Heo wrote:
> This isn't strictly necessary as all subsystems specified in
> @subsys_mask are guaranteed to be pinned; however, it does spuriously
> trigger lockdep warning.  Let's grab cgroup_mutex around it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Li Zefan <lizefan@huawei.com>

