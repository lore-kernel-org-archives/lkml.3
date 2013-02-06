Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab3BFSSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:18:01 -0500
Received: from mga03.intel.com ([143.182.124.21]:64531 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757880Ab3BFSRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:17:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,617,1355126400"; 
   d="scan'208";a="199405950"
Date: Wed, 6 Feb 2013 19:17:52 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: ptyser@xes-inc.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] mfd: lpc_ich: Fix arguments to kmalloc
Message-ID: <20130206181752.GD3418@sortiz-mobl>
References: <1360173659-22409-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360173659-22409-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Emil,

On Wed, Feb 06, 2013 at 07:00:59PM +0100, Emil Goode wrote:
> This patch changes the order of the arguments to kmalloc,
> the allocation flag should be the second argument.
> 
> Sparse warnings:
> 
> drivers/mfd/lpc_ich.c:881:24: warning:
> 	incorrect type in argument 1 (different base types)
> 	drivers/mfd/lpc_ich.c:881:24:
> 	expected unsigned long [unsigned] [usertype] size
> 	drivers/mfd/lpc_ich.c:881:24:    got restricted gfp_t
> 
> drivers/mfd/lpc_ich.c:881:36: warning:
> 	incorrect type in argument 2 (different base types)
> 	drivers/mfd/lpc_ich.c:881:36:
> 	expected restricted gfp_t [usertype] flags
> 	drivers/mfd/lpc_ich.c:881:36:    got unsigned long
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
>  drivers/mfd/lpc_ich.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
This patch does not apply to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
