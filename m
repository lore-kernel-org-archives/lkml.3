Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601Ab3GaLfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:35:24 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:50042 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab3GaLfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:35:22 -0400
Date: Wed, 31 Jul 2013 07:35:18 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 4/7] cgroup: rename cgroup_pidlist->mutex
Message-ID: <20130731113518.GJ2810@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C818.4080308@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F8C818.4080308@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 04:17:28PM +0800, Li Zefan wrote:
> It's a semaphore not a mutex.

It's not even a normal semaphore.  Maybe naming it rwsem is better?

Thanks.

-- 
tejun
