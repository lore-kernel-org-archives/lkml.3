Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbaEFLbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:31:52 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:60082 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaEFLbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:31:51 -0400
Date: Tue, 6 May 2014 07:31:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] kernel/cpuset.c: kernel-doc fixes
Message-ID: <20140506113148.GA27738@htj.dyndns.org>
References: <20140505194655.6d1304a0826c107debdbbe30@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505194655.6d1304a0826c107debdbbe30@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 07:46:55PM +0200, Fabian Frederick wrote:
> This patch also converts seq_printf to seq_puts
> 
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
