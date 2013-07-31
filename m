Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540Ab3GaKmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:42:17 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:50642 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3GaKmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:42:15 -0400
Date: Wed, 31 Jul 2013 06:42:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/7] cgroup: remove sparse tags from offline_css()
Message-ID: <20130731104212.GG2810@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C7E8.1080909@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F8C7E8.1080909@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 04:16:40PM +0800, Li Zefan wrote:
> This should have been removed in commit d7eeac1913ff
> ("cgroup: hold cgroup_mutex before calling css_offline").
> 
> While at it, update the comments.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
