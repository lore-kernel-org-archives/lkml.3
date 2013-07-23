Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab3GWQRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:17:32 -0400
Received: from mail-gg0-f171.google.com ([209.85.161.171]:51877 "EHLO
	mail-gg0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299Ab3GWQRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:17:30 -0400
X-Greylist: delayed 67008 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jul 2013 12:17:30 EDT
Date: Tue, 23 Jul 2013 12:17:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 1/3] vmpressure: change vmpressure::sr_lock to
 spinlock
Message-ID: <20130723161724.GA21100@mtj.dyndns.org>
References: <1374252671-11939-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374252671-11939-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

Sorry about the delay.  Was on the road.

On Fri, Jul 19, 2013 at 06:51:09PM +0200, Michal Hocko wrote:
> There is nothing that can sleep inside critical sections protected by
> this lock and those sections are really small so there doesn't make much
> sense to use mutex for them. Change the log to a spinlock
> 
> Brought-up-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
