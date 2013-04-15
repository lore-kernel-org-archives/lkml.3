Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab3DODSJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 23:18:09 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:53506 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3DODSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 23:18:07 -0400
Date: Sun, 14 Apr 2013 20:17:54 -0700
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, glommer@parallels.com, vgoyal@redhat.com
Subject: Re: [PATCHSET] cgroup, memcg: introduce sane_behavior mount option
Message-ID: <20130415031754.GG3050@htj.dyndns.org>
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365808259-31073-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 04:10:55PM -0700, Tejun Heo wrote:
> To make progress, those behaviors need to go but we can't simply drop
> or change the crazies as those are directly visible to userland.  This
> patchset implements a mount option - sane_behavior - which turns on
> new saner behaviors, so that we can keep providing the old behaviors
> while and after transitioning to saner ones.

Applied 1-3 to cgroup/for-3.10.  Michal, I left the last memcg one
out.  Please let me know how you wanna route it.

Thanks.

-- 
tejun
