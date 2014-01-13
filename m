Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaAMPtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:49:05 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:58468 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaAMPtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:49:00 -0500
Date: Mon, 13 Jan 2014 10:48:54 -0500
From: Tejun Heo <tj@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm/next] cgroup: remove stray references to css_id
Message-ID: <20140113154854.GA29053@htj.dyndns.org>
References: <alpine.LSU.2.11.1401122018400.1701@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1401122018400.1701@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 08:23:27PM -0800, Hugh Dickins wrote:
> Trivial: remove the few stray references to css_id, which itself
> was removed in v3.13's 2ff2a7d03bbe "cgroup: kill css_id".
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Applied to cgroup/for-3.14.

Thanks.

-- 
tejun
