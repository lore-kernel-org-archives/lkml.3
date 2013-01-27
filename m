Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab3A0Xxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 18:53:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:30238 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756926Ab3A0Xx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 18:53:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,547,1355126400"; 
   d="scan'208";a="253318969"
Date: Mon, 28 Jan 2013 00:53:27 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Philippe Langlais <philippe.langlais@linaro.org>
Subject: Re: [PATCH 14/26] mfd: ab8500-debugfs: Fix introduced compiler time
 warnings
Message-ID: <20130127235327.GR1174@sortiz-mobl>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-15-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358254566-12419-15-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Jan 15, 2013 at 12:55:54PM +0000, Lee Jones wrote:
> From: Philippe Langlais <philippe.langlais@stericsson.com>
> 
> Some simple fixes regarding pre-processor usage.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
> ---
>  drivers/mfd/ab8500-debugfs.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
Here again, please squash this one with the previous one.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
