Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660Ab3GaLjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:39:03 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:44253 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab3GaLjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:39:00 -0400
Date: Wed, 31 Jul 2013 07:38:57 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 6/7] cgroup: rename current_css_set_cg_links
Message-ID: <20130731113857.GM2810@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C83F.6010407@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F8C83F.6010407@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 31, 2013 at 04:18:07PM +0800, Li Zefan wrote:
> As we've renamed css_set->cg_links to css_set->cgrp_links (See commit
> 69d0206c79 "cgroup: bring some sanity to naming around cg_cgroup_link"),
> it's better to also rename the debug file.
> 
> As the "debug" cgroup subsystem is for debug only and acts as a sample
> on how to write a cgroup subsystem, it's fine to change the interface.

I'd rather not do this.  It doesn't really buy us anything and stuff
like cgrp_links isn't interesting to actual controllers anyway.

Thanks.

-- 
tejun
