Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab3GINQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 09:16:11 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37999 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab3GINQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 09:16:09 -0400
Date: Tue, 9 Jul 2013 06:16:05 -0700
From: Tejun Heo <tj@kernel.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Message-ID: <20130709131605.GB2478@htj.dyndns.org>
References: <20130708100046.14417.12932.stgit@zurg>
 <20130708170047.GA18600@mtj.dyndns.org>
 <20130708175201.GB9094@redhat.com>
 <20130708175607.GB18600@mtj.dyndns.org>
 <51DBC99F.4030301@openvz.org>
 <20130709125734.GA2478@htj.dyndns.org>
 <51DC0CE2.2050906@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DC0CE2.2050906@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 05:15:14PM +0400, Konstantin Khlebnikov wrote:
> blkio controls block devices. not filesystems or superblocks or bdi or pagecache.
> It's all about block layer and nothing more. Am I right?
> 
> So, you want to link some completely unrelated subsystems like NFS into the block layer?

Heh, yeah, sure, network QoS is completely unrelated to sockets too,
right?

-- 
tejun
