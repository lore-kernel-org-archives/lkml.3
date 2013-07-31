Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631Ab3GaLgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:36:25 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:65024 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab3GaLgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:36:23 -0400
Date: Wed, 31 Jul 2013 07:36:19 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] cgroup: remove struct cgroup_seqfile_state
Message-ID: <20130731113619.GL2810@htj.dyndns.org>
References: <51F8DA99.3010303@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F8DA99.3010303@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 05:36:25PM +0800, Li Zefan wrote:
> We can use struct cfent instead.
> 
> v2:
> - remove cgroup_seqfile_release().
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to libata/for-3.12.

Thanks.

-- 
tejun
