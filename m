Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3KUCTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 21:19:17 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43865 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab3KUCTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 21:19:13 -0500
Message-ID: <528D6E19.4080100@gmail.com>
Date: Thu, 21 Nov 2013 10:21:13 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Chen Gang <gang.chen@asianux.com>, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] kernel: cgroup: mount failure in LTP cgroup_regression_test.sh
References: <527C9D9B.8090802@asianux.com> <20131120173549.GO28946@htj.dyndns.org>
In-Reply-To: <20131120173549.GO28946@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 01:35 AM, Tejun Heo wrote:
> Hello,
> 
> Sorry about the delay.
> 

Oh, No problem, every members time resources are expensive, thank you
for your reply.


> On Fri, Nov 08, 2013 at 04:15:23PM +0800, Chen Gang wrote:
>> After simplify, the related operation, environments and output are:
>>
>>   [root@gchenlinux tmp]# df -Th | grep cgroup
>>   tmpfs                             tmpfs    1001M     0 1001M   0% /sys/fs/cgroup
>>   [root@gchenlinux tmp]# lsof | grep cgroup | grep -v grep
>>   systemd       1          root    6r      DIR               0,18         0       5998 /sys/fs/cgroup/systemd/system
>>   [root@gchenlinux tmp]# cat /proc/cgroups 
>>   #subsys_name	hierarchy	num_cgroups	enabled
>>   cpuset	3	4	1
>>   cpu	4	35	1
>>   cpuacct	4	35	1
>>   freezer	5	4	1
>>   [root@gchenlinux tmp]# mkdir cgroup
>>   [root@gchenlinux tmp]# mount -t cgroup -o freezer,cpuacct xxx cgroup/
>>   mount: xxx already mounted or cgroup/ busy
>>
>> Is it real issue of cgroup? If it is, I will/should continue analyzing.
> 
> Hmmm... I'm a bit confused.  What is it testing?  "cat /proc/cgroup"
> is showing that freezer is already mounted and the kernel seems to
> have correctly refused to mount it in a different hierarchy.  What am
> I missing here?
> 

Hmm... I am not quit familiar about it, either, but at least I can
contact related LTP members (I guess they can make sure about it).


Excuse me, I am changing/finding new job, so I should not use Asianux
Corporation mail again.  And it seems I can not be focus on upstream
kernel as much as before.  :-(

But at least, I will/should continue providing some contributions (more
or less) to Public Open Source as volunteers. And for upstream kernel,
I plan to make 1-3 patches per month (mainly for cross compiling).

 - if can not get companies support, I can not provide enough time
   resource on upstream kernel (I have to get pay check for family).

 - New company may mainly focus on open source tool chains (not only
   kernel), so I will/should also provide some contributions to them
   (e.g. KVM, GCC ...).


At last, sorry again for I have to give up 10 patches per month for
upstream kernel.


Thanks.
-- 
Chen Gang
