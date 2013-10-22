Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3JVCfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 22:35:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:51257 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab3JVCfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 22:35:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="378037251"
Date: Mon, 21 Oct 2013 19:35:39 -0700
From: Jon Mason <jon.mason@intel.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NTB: remove duplicate defines
Message-ID: <20131022023539.GD29998@jonmason-lab>
References: <1382332782-5686-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382332782-5686-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 07:19:42AM +0200, Michael Opdenacker wrote:
> Remove duplicate defines in drivers/ntb/ntb_regs.h
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Applied to my next tree, which should go into 3.13.

Thanks,
Jon

> ---
>  drivers/ntb/ntb_regs.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/ntb/ntb_regs.h b/drivers/ntb/ntb_regs.h
> index aa4bdd3..caa5975 100644
> --- a/drivers/ntb/ntb_regs.h
> +++ b/drivers/ntb/ntb_regs.h
> @@ -75,9 +75,6 @@
>  #define SNB_SBAR2XLAT_OFFSET	0x0030
>  #define SNB_SBAR4XLAT_OFFSET	0x0038
>  #define SNB_SBAR0BASE_OFFSET	0x0040
> -#define SNB_SBAR0BASE_OFFSET	0x0040
> -#define SNB_SBAR2BASE_OFFSET	0x0048
> -#define SNB_SBAR4BASE_OFFSET	0x0050
>  #define SNB_SBAR2BASE_OFFSET	0x0048
>  #define SNB_SBAR4BASE_OFFSET	0x0050
>  #define SNB_NTBCNTL_OFFSET	0x0058
> -- 
> 1.8.1.2
> 
