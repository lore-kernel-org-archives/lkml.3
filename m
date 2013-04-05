Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162002Ab3DEQLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:11:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:16997 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161930Ab3DEQLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:11:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,415,1363158000"; 
   d="scan'208";a="314200140"
Date: Fri, 5 Apr 2013 18:11:01 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd: abx500 move the AB8500 Kconfig fragment
Message-ID: <20130405161101.GM17363@zurbaran>
References: <1363272864-16183-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363272864-16183-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Mar 14, 2013 at 03:54:24PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Move the AB8500 Kconfig fragment below the AB3100 so the
> menuconfig menu gets hierarchically nested and looks nice.
> Having the EZX PCAP in the middle disturbs the nice
> hierarchical layout from kconfig.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> NOTE: it might look like this code is only touching the EZX
> PCAP config fragment, but that is not the semantic effect,
> that affects only the ABx500's.
> ---
>  drivers/mfd/Kconfig | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
