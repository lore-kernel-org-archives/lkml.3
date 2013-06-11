Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab3FKMkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 08:40:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:55649 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab3FKMkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 08:40:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,845,1363158000"; 
   d="scan'208";a="351675904"
Message-ID: <1370954397.29283.329.camel@smile>
Subject: Re: [PATCH v2 0/4] dw_dmac: move to own folder and split
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        viresh.kumar@linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <balbi@ti.com>
Date: Tue, 11 Jun 2013 15:39:57 +0300
In-Reply-To: <1370435206-13474-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1370435206-13474-1-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 15:26 +0300, Andy Shevchenko wrote: 
> This is split of the dw_dmac driver as suggested by Arnd et al [1,2].
> There are three most important patches:
>  2/4 moves driver to its own folder
>  3/4 does the actual split
>  4/4 introduces PCI part of the driver
> 
> During this files are renamed: mostly means that dw_dmac prefix is eliminated.
> I hope to get it ready to be included in v3.11.
> 
> [1] http://www.spinics.net/lists/kernel/msg1408174.html
> [2] http://www.spinics.net/lists/kernel/msg1408495.html
> 
> Changes v1->v2:
>  - address Arnd's comments
>  - compile test when !CONFIG_PM
>  - apply ACKs
> 
> Cnages v0->v1:
>  - apply Viresh's ACKs
>  - append PCI part of the driver
>  - test altogether on Intel Medfield
>  - add 1/4 to the series as it based on it, but Vinod didn't apply it yet to
>    his tree.

Vinod, do you have any comments on this?

We would like to have this scheduled for v3.11.
I think we still have few days if you think we need to improve this
patchset.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
