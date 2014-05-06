Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbaEFLcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:32:06 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:57885 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaEFLcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:32:04 -0400
Date: Tue, 6 May 2014 07:32:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] kernel/cpuset.c: convert printk to pr_foo()
Message-ID: <20140506113201.GB27738@htj.dyndns.org>
References: <20140505194900.a0679fd326208e0b56e51f5e@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505194900.a0679fd326208e0b56e51f5e@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 07:49:00PM +0200, Fabian Frederick wrote:
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
