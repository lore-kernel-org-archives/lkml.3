Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936914Ab3DIIKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:10:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:47369 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935136Ab3DIIKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:10:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,437,1363158000"; 
   d="scan'208";a="292212989"
Date: Tue, 9 Apr 2013 10:10:28 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        David Dajun Chen <dchen@diasemi.com>
Subject: Re: [patch v1] mfd: da9055 change irq state to default
Message-ID: <20130409081028.GH24058@zurbaran>
References: <1363597958.4228.7.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363597958.4228.7.camel@dhruva>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

On Mon, Mar 18, 2013 at 02:42:38PM +0530, Ashish Jangam wrote:
> This patch changes the irq state from high to the now default low.
> Because the default PMIC irq state of DA9055 got changed from high to low.
> This change should not affect any of the existing users since all of them
> use active low state.
> 
> This patch has been tested on smdkv6410.
> 
> Signed-off-by: Ashish <ashish.jangam@kpitcummins.com>
> 
> ---
>  drivers/mfd/da9055-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
