Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3HANap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:30:45 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48795 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3HANam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:30:42 -0400
Date: Thu, 1 Aug 2013 09:30:38 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 4/7] cgroup: rename cgroup_pidlist->mutex
Message-ID: <20130801133038.GE24966@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C818.4080308@huawei.com>
 <20130731113518.GJ2810@htj.dyndns.org>
 <51F9BF4F.5030704@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F9BF4F.5030704@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 09:52:15AM +0800, Li Zefan wrote:
> It's a rw_semaphore not a mutex.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
