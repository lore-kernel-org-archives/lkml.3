Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaBYOnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:43:06 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:51320 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbaBYOnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:43:00 -0500
Date: Tue, 25 Feb 2014 09:42:56 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v3] sysfs: fix namespace refcnt leak
Message-ID: <20140225144256.GB26788@htj.dyndns.org>
References: <530C7E6C.2020500@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530C7E6C.2020500@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 07:28:44PM +0800, Li Zefan wrote:
> As mount() and kill_sb() is not a one-to-one match, we shoudn't get
> ns refcnt unconditionally in sysfs_mount(), and instead we should
> get the refcnt only when kernfs_mount() allocated a new superblock.
> 
> v2:
> - Changed the name of the new argument, suggested by Tejun.
> - Made the argument optional, suggested by Tejun.
> 
> v3:
> - Make the new argument as second-to-last arg, suggested by Tejun.
> 
> Reviewed-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Li Zefan <lizefan@huawei.com>

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
