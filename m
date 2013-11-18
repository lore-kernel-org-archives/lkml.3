Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3KRJ3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:29:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:3512 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab3KRJ3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:29:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,722,1378882800"; 
   d="scan'208";a="435259453"
Date: Mon, 18 Nov 2013 10:29:13 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Cyril Chemparathy <cyril@ti.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: ti-ssp: Fix build
Message-ID: <20131118092913.GD17681@zurbaran>
References: <1384714435-30474-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384714435-30474-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Sun, Nov 17, 2013 at 07:53:55PM +0100, Geert Uytterhoeven wrote:
>     drivers/mfd/ti-ssp.c: In function 'ti_ssp_run':
>     drivers/mfd/ti-ssp.c:286:2: error: implicit declaration of function 'set_current_state' [-Werror=implicit-function-declaration]
>     drivers/mfd/ti-ssp.c:286:381: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
>     drivers/mfd/ti-ssp.c:286:381: note: each undeclared identifier is reported only once for each function it appears in
>     drivers/mfd/ti-ssp.c:286:2: error: implicit declaration of function 'signal_pending' [-Werror=implicit-function-declaration]
>     drivers/mfd/ti-ssp.c:286:2: error: implicit declaration of function 'schedule' [-Werror=implicit-function-declaration]
>     drivers/mfd/ti-ssp.c:286:2: error: implicit declaration of function '__set_current_state' [-Werror=implicit-function-declaration]
>     drivers/mfd/ti-ssp.c:286:742: error: 'TASK_RUNNING' undeclared (first use in this function)
>     drivers/mfd/ti-ssp.c: In function 'ti_ssp_interrupt':
>     drivers/mfd/ti-ssp.c:311:32: error: 'TASK_NORMAL' undeclared (first use in this function)
> 
> Add missing #include <linux/sched.h>.
> 
>     drivers/mfd/ti-ssp.c: In function 'ti_ssp_probe':
>     drivers/mfd/ti-ssp.c:412:12: error: 'struct mfd_cell' has no member named 'data_size'
>
Applied to mfd-fixes, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
