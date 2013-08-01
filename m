Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab3HABLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 21:11:23 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:27823 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3HABLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 21:11:21 -0400
Message-ID: <51F9B5A6.4050905@huawei.com>
Date: Thu, 1 Aug 2013 09:11:02 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 5/7] cgroup: remove struct cgroup_seqfile_state
References: <51F8C7C5.9040608@huawei.com> <51F8C829.3040708@huawei.com> <51F8D88B.2040400@huawei.com> <20130731113557.GK2810@htj.dyndns.org>
In-Reply-To: <20130731113557.GK2810@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/31 19:35, Tejun Heo wrote:
> On Wed, Jul 31, 2013 at 05:27:39PM +0800, Li Zefan wrote:
>>>  static int cgroup_seqfile_release(struct inode *inode, struct file *file)
>>>  {
>>> -	struct seq_file *seq = file->private_data;
>>> -	kfree(seq->private);
>>>  	return single_release(inode, file);
>>>  }
>>
>> Oh, I just realized now we can remove cgroup_seqfile_release().
>>
>> Will send out an updated patch...
> 
> Applied the updated patch.  Can you please post updated patches as
> replies to the original path from next time?  That makes things easier
> to track on my side.
> 

Sure.

