Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab3GXRdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:33:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3GXRds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:33:48 -0400
Date: Wed, 24 Jul 2013 10:33:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liu Xuezhao <xuezhao.liu@emc.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH-RESEND 5/8] staging/lustre/obdclass: add obd_target.h
Message-ID: <20130724173347.GA17645@kroah.com>
References: <1374686251-3152-1-git-send-email-bergwolf@gmail.com>
 <1374686251-3152-6-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374686251-3152-6-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 01:17:28AM +0800, Peng Tao wrote:
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

This patch doesn't apply cleanly due to some other patches I took
earlier today, can you please refresh it and resend it?

thanks,

greg k-h
