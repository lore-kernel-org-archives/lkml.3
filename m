Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3GaLgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:36:03 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:45539 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab3GaLgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:36:01 -0400
Date: Wed, 31 Jul 2013 07:35:57 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 5/7] cgroup: remove struct cgroup_seqfile_state
Message-ID: <20130731113557.GK2810@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C829.3040708@huawei.com>
 <51F8D88B.2040400@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F8D88B.2040400@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 05:27:39PM +0800, Li Zefan wrote:
> >  static int cgroup_seqfile_release(struct inode *inode, struct file *file)
> >  {
> > -	struct seq_file *seq = file->private_data;
> > -	kfree(seq->private);
> >  	return single_release(inode, file);
> >  }
> 
> Oh, I just realized now we can remove cgroup_seqfile_release().
> 
> Will send out an updated patch...

Applied the updated patch.  Can you please post updated patches as
replies to the original path from next time?  That makes things easier
to track on my side.

Thanks.

-- 
tejun
