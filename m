Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935762Ab3DHMYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:24:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935664Ab3DHMYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:24:52 -0400
Date: Mon, 8 Apr 2013 08:24:42 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH cgroup/for-3.10] devcg: remove broken_hierarchy tag
Message-ID: <20130408122442.GD24899@redhat.com>
References: <20130407172818.GD12038@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130407172818.GD12038@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 07, 2013 at 10:28:18AM -0700, Tejun Heo wrote:
> From f913fbedbdfc08eeff742c4b3077e267d8fc867f Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Sun, 7 Apr 2013 10:25:39 -0700
> 
> bd2953ebbb ("devcg: propagate local changes down the hierarchy")
> implemented proper hierarchy support.  Remove the broken tag.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Aristeu Rozanski <aris@redhat.com>
> ---
> Applying to cgroup/for-3.10.

looks good, thanks Tejun

Acked-by: Aristeu Rozanski <aris@redhat.com>

-- 
Aristeu

