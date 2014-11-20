Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbaKTUQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 15:16:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212AbaKTUQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 15:16:13 -0500
Date: Thu, 20 Nov 2014 15:16:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH block/for-next 2/4] blkcg: add blkcg_root_css
Message-ID: <20141120201609.GE6999@redhat.com>
References: <20141117211321.GD23126@htj.dyndns.org>
 <20141117211357.GE23126@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117211357.GE23126@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 04:13:57PM -0500, Tejun Heo wrote:
[..]
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1408,6 +1408,9 @@ int kblockd_schedule_delayed_work(struct
>  int kblockd_schedule_delayed_work_on(int cpu, struct delayed_work *dwork, unsigned long delay);
>  
>  #ifdef CONFIG_BLK_CGROUP
> +
> +extern struct cgroup_subsys_state * const blkcg_root_css;

Hi Tejun,

Would it make sense to keep this in include/linux/blk-cgroup.h

Thanks
Vivek
