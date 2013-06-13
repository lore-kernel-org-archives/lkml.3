Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab3FMRtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:49:43 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:36581 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab3FMRtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:49:42 -0400
Date: Thu, 13 Jun 2013 10:49:36 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH v3 0/7] cpuset: implement sane hierarchy behaviors
Message-ID: <20130613174936.GA10799@mtj.dyndns.org>
References: <51B4475A.8030509@huawei.com>
 <20130609160353.GE2835@htj.dyndns.org>
 <51B96F04.30803@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B96F04.30803@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 03:04:36PM +0800, Li Zefan wrote:
> I would prefer those patches are applied first, as the new changes can
> be based on this patchset, and the changes should be quite straightforward,
> and also I don't have to rebase those patches again.

Aye aye, applied the rest of the series to cgroup/for-3.11-cpuset.
Thanks!

-- 
tejun
