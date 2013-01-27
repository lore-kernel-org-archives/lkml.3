Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab3A0XxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 18:53:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:17273 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab3A0XxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 18:53:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,547,1355126400"; 
   d="scan'208";a="279037756"
Date: Mon, 28 Jan 2013 00:53:09 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 10/26] mfd: ab8500-debugfs: Wake-up device on debugfs IRQ
Message-ID: <20130127235309.GP1174@sortiz-mobl>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-11-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358254566-12419-11-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Jan 15, 2013 at 12:55:50PM +0000, Lee Jones wrote:
> Ensure the device wakes up if the debugfs IRQ fires if we're
> in suspend mode.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/ab8500-debugfs.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
Please squash this one with the previous one.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
