Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3AXSgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:36:44 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:54081 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3AXSgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:36:42 -0500
Date: Thu, 24 Jan 2013 10:36:36 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] cgroup: fix exit() vsrmdir() race
Message-ID: <20130124183636.GM2373@mtj.dyndns.org>
References: <5100D810.5020406@huawei.com>
 <20130124181923.GK2373@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124181923.GK2373@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 10:19:23AM -0800, Tejun Heo wrote:
> * cgroup_release_agent() seems broken too.  It's accessing cgrp after
>   removing it from release_list.  Can you please fix it too?

Oh, we should be okay as we're holding cgroup_mutex there.  Please
forget about the above.

Thanks.

-- 
tejun
