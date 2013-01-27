Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab3A0Xxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 18:53:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:61274 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756978Ab3A0Xxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 18:53:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,547,1355126400"; 
   d="scan'208";a="277253474"
Date: Mon, 28 Jan 2013 00:53:48 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Naga Radhesh <naga.radheshy@stericsson.com>
Subject: Re: [PATCH 23/26] mfd: ab8500-pwm: Enable support for AB8505 PWMLED
 blink
Message-ID: <20130127235348.GT1174@sortiz-mobl>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-24-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358254566-12419-24-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Jan 15, 2013 at 12:56:03PM +0000, Lee Jones wrote:
> From: Naga Radhesh <naga.radheshy@stericsson.com>
> 
> Enable support for PWM OUT LED blinking for AB8505. Instead of
> having 3 pwm instances from ab8500 core file add it as platform data.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Naga Radhesh <naga.radheshy@stericsson.com>
> Reviewed-by: Arun MURTHY <arun.murthy@stericsson.com>
> Reviewed-by: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
> ---
>  drivers/mfd/ab8500-core.c          |   10 --
>  drivers/misc/ab8500-pwm.c          |  282 ++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/ab8500/pwmleds.h |   20 +++
>  include/linux/mfd/abx500/ab8500.h  |    2 +
>  4 files changed, 304 insertions(+), 10 deletions(-)
>  create mode 100644 drivers/misc/ab8500-pwm.c
This pretty much looks like the already existing and PWM API compliant
drivers/pwm/ab8500-pwm.c. What's the point here ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
