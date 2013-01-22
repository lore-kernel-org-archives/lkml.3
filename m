Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab3AVDZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:25:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:19721 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab3AVDZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:25:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,511,1355126400"; 
   d="scan'208";a="250508336"
Date: Tue, 22 Jan 2013 04:25:27 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd: ab8500: update header file and version detection
Message-ID: <20130122032527.GH7409@sortiz-mobl>
References: <1357512499-6009-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357512499-6009-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sun, Jan 06, 2013 at 11:48:19PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This updates the AB8500 register map with defines for a few
> new chip variants and adds version detection helpers to handle
> the different variants.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Hi Sam, it'd be great if you could ACK this because I need the
> new interface as a base to remove the broken gpio-ab8500 driver
> and put in place a new pinctrl driver instead.
> ---
>  include/linux/mfd/abx500/ab8500.h | 277 ++++++++++++++++++++++++++++++--------
>  1 file changed, 222 insertions(+), 55 deletions(-)
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
