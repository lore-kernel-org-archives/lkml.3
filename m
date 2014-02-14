Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaBNP54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 10:57:56 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:39419 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaBNP5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 10:57:55 -0500
Date: Fri, 14 Feb 2014 10:57:51 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/3] cgroup: fix locking in cgroupstats_build()
Message-ID: <20140214155751.GB31544@htj.dyndns.org>
References: <52FDD9C4.1070001@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FDD9C4.1070001@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 04:54:28PM +0800, Li Zefan wrote:
> css_set_lock has been converted to css_set_rwsem, and rwsem can't
> nested inside rcu_read_lock.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied 1-3 to cgroup/for-3.15.

Thanks!

-- 
tejun
