Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab3BGHr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 02:47:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:19384 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab3BGHr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 02:47:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,619,1355126400"; 
   d="scan'208";a="199609719"
Date: Thu, 7 Feb 2013 08:47:50 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] mfd: ab8500: fix compile error
Message-ID: <20130207074750.GF3418@sortiz-mobl>
References: <1360189381-3259-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360189381-3259-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Feb 06, 2013 at 11:23:01PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> When compiling the AB8500 core driver in the latest
> MFD tree the following happens:
> 
>   CC      drivers/mfd/ab8500-debugfs.o
> /home/elinwal/linux-next/drivers/mfd/ab8500-debugfs.c:157:3: error: 'AB8500_SYS_CTRL1_BLOCK' undeclared here (not in a function)
> /home/elinwal/linux-next/drivers/mfd/ab8500-debugfs.c:157:2: error: array index in initializer not of integer type
> /home/elinwal/linux-next/drivers/mfd/ab8500-debugfs.c:157:2: error: (near initialization for 'debug_ranges')
> (...)
> 
> This is due to a missing include statement, so fix
> it up.
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/ab8500-debugfs.c | 1 +
>  1 file changed, 1 insertion(+)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
