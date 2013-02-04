Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab3BDTR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:17:28 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:40556 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3BDTR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:17:26 -0500
Date: Mon, 4 Feb 2013 11:17:20 -0800
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing users
Message-ID: <20130204191720.GW27963@mtj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I rolled up all the updates and rebased it on top of today's
linux-next (20130204).

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git convert-to-idr_alloc

The git branch contains the following.

  [1] [PATCH] idr: fix a subtle bug in idr_get_next()
+ [2] [PATCHSET] idr: deprecate idr_remove_all()
+ [3] [PATCHSET] idr: implement idr_alloc() and convert existing users (w/ all updates)

The only conflict from rebasing it on top of -next is in
drm_get_connector_status_name() which moved id assignment inside mutex
and trivial to resolve.

Given the size of the patchset, I'm waiting a bit more before
reposting the whole thing.  If anyone wants it reposted now, please
let me know.

Thanks.

-- 
tejun

[1] https://lkml.org/lkml/2013/2/2/145
[2] https://lkml.org/lkml/2013/1/25/759
[3] https://lkml.org/lkml/2013/2/2/159
