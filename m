Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab3CMBnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 21:43:41 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:1045 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab3CMBnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 21:43:39 -0400
Message-ID: <513FD9C1.4020604@huawei.com>
Date: Wed, 13 Mar 2013 09:43:29 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2] cgroup: consolidate cgroup_attach_task() and cgroup_attach_proc()
References: <513FD395.7000906@huawei.com> <20130313011939.GC2999@htj.dyndns.org>
In-Reply-To: <20130313011939.GC2999@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/13 9:19, Tejun Heo wrote:
> On Wed, Mar 13, 2013 at 09:17:09AM +0800, Li Zefan wrote:
>> These two functions share most of the code.
>>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
>> ---
>>
>> v2: Not necessary to move cgroup_attach_task_all().
> 
> I supposed this one is the one to apply?
> 

yep.

