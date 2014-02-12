Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaBLIwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:52:33 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:58018 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaBLIwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:52:31 -0500
Message-ID: <52FB3642.1050509@huawei.com>
Date: Wed, 12 Feb 2014 16:52:18 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 6/8] cgroup: remove cgroup->name
References: <1391877509-10855-1-git-send-email-tj@kernel.org> <1391877509-10855-7-git-send-email-tj@kernel.org> <52FB2834.3090408@huawei.com> <20140212082713.GD7984@mtj.dyndns.org>
In-Reply-To: <20140212082713.GD7984@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/12 16:27, Tejun Heo wrote:
> On Wed, Feb 12, 2014 at 03:52:20PM +0800, Li Zefan wrote:
>> The caller won't check the return value but pass it to printk/seq_printf,
>> but now cgroup_path() might return -ENAMETOOLONG..
> 
> cgroup_path() returns NULL on overflow which printk handles fine, no?
> 

Ah, right. My mistake. I didn't take an afternoon nap, and was a bit sleeply.

