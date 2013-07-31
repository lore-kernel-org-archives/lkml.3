Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138Ab3GaJ3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:29:08 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:54484 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab3GaJ3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:29:06 -0400
Message-ID: <51F8D88B.2040400@huawei.com>
Date: Wed, 31 Jul 2013 17:27:39 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 5/7] cgroup: remove struct cgroup_seqfile_state
References: <51F8C7C5.9040608@huawei.com> <51F8C829.3040708@huawei.com>
In-Reply-To: <51F8C829.3040708@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static int cgroup_seqfile_release(struct inode *inode, struct file *file)
>  {
> -	struct seq_file *seq = file->private_data;
> -	kfree(seq->private);
>  	return single_release(inode, file);
>  }

Oh, I just realized now we can remove cgroup_seqfile_release().

Will send out an updated patch...

