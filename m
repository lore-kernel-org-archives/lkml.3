Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab3GWUlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:41:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3GWUlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:41:21 -0400
Date: Tue, 23 Jul 2013 13:41:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liu Xuezhao <xuezhao.liu@emc.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 36/48] staging/lustre/obdclass: add obd_target.h
Message-ID: <20130723204120.GA12687@kroah.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
 <1374509230-3324-37-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374509230-3324-37-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 12:06:57AM +0800, Peng Tao wrote:
> From: Liu Xuezhao <xuezhao.liu@emc.com>
> 
> Move some server-side data structures form obd.h to obd_target.h.  To
> remove some code dependencies use HAVE_SERVER_SUPPORT to protect some
> llog/fsfilt_* functions.
> 
> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-1330
> Lustre-change: http://review.whamcloud.com/2678
> Signed-off-by: Liu Xuezhao <xuezhao.liu@emc.com>
> Signed-off-by: John L. Hammond <john.hammond@intel.com>
> Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
> Reviewed-by: Peng Tao <bergwolf@gmail.com>
> Reviewed-by: Mike Pershin <mike.pershin@intel.com>
> Signed-off-by: Peng Tao <tao.peng@emc.com>
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> ---
>  .../lustre/lustre/include/linux/lustre_fsfilt.h    |   10 -
>  .../staging/lustre/lustre/include/lprocfs_status.h |   36 --
>  drivers/staging/lustre/lustre/include/obd.h        |  140 +----
>  drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |    1 -
>  drivers/staging/lustre/lustre/obdclass/Makefile    |    2 +-

This patch has too much fuzz to apply properly, please refresh and
resend.

thanks,

greg k-h
