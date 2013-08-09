Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966917Ab3HIANK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:13:10 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:48378 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966748Ab3HIANI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:13:08 -0400
Date: Thu, 8 Aug 2013 20:13:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH cgroup/for-3.12] cgroup: make css_for_each_descendant()
 and friends include the origin css in the iteration
Message-ID: <20130809001302.GB13427@mtj.dyndns.org>
References: <20130804230703.GA12029@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130804230703.GA12029@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 04, 2013 at 07:07:03PM -0400, Tejun Heo wrote:
> Hello,
> 
> I've been wanting to do this for some time and given all the recent
> API updates now seems like a pretty good opportunity.  Verified
> freezer and blkcg.  The conversions are mostly straight forward but
> I'd much appreciate acks from controller maintainers.

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
