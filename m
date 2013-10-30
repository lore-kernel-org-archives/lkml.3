Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab3J3QgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:36:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3J3QgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:36:20 -0400
Date: Wed, 30 Oct 2013 09:36:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel@googlegroups.com, Minchan Kim <minchan@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/3] Staging: zram: Fix variable dereferenced before
 check
Message-ID: <20131030163619.GA15538@kroah.com>
References: <3d7e050910ca994862e7880b4bd3681267681b56.1383138164.git.rashika.kheria@gmail.com>
 <a73fda4aab5db355a97488d6a87d20b8e1778b5c.1383138164.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a73fda4aab5db355a97488d6a87d20b8e1778b5c.1383138164.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 06:43:32PM +0530, Rashika Kheria wrote:
> This patch fixes the following Smatch warning in zram_drv.c-
> drivers/staging/zram/zram_drv.c:899
> destroy_device() warn: variable dereferenced before check 'zram->disk' (see line 896)
> 
> Acked-by: Minchan Kim <minchan@kernel.org>
> Acked-by: Jerome Marchand <jmarchan@redhat.com>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> ---
> 
> This revision fixes the following issues of the previous revision-
> Removes Cc to stable@vger.kernel.org as it is just a Smatch warning fix

Applied, thanks.

greg k-h
