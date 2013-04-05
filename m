Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162001Ab3DEQHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:07:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:34997 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161950Ab3DEQHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:07:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,415,1363158000"; 
   d="scan'208";a="314197714"
Date: Fri, 5 Apr 2013 18:07:00 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/2] mfd: stmpe: DT: Add stmpe-i2c dt alias to get id
 device
Message-ID: <20130405160700.GK17363@zurbaran>
References: <1362139646-23613-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362139646-23613-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Mar 01, 2013 at 01:07:26PM +0100, Linus Walleij wrote:
> From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
> 
> This patch augments the STMP driver to read the device id
> from the stmpe-i2c dt alias if present.
> 
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/stmpe.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
Applied to mfd-next as well.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
