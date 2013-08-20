Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab3HTBSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 21:18:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:18323 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab3HTBSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 21:18:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,915,1367996400"; 
   d="scan'208";a="348662227"
Date: Tue, 20 Aug 2013 03:18:49 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Subject: Re: [PATCH v3 0/6] Add Dialog DA9063 core and regulator drivers
Message-ID: <20130820011849.GC13324@zurbaran>
References: <1375117247-6376-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375117247-6376-1-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Mon, Jul 29, 2013 at 07:00:41PM +0200, Philipp Zabel wrote:
> Hi,
> 
> here is the third round of the DA9063 mfd core and regulator patches, with the
> following changes since v2:
>  - Split DA9063 core driver patch into three more digestible parts
>    (register definitions, core mfd/i2c driver, regmap irqchip support)
I applied those 3 patches to mfd-next, and dropped patch #6.


>  - Removed 32k clock output from the regulator driver
>  - Added device tree binding documentation
I suppose I should carry this one as well. I'll wait a bit more to see
if we get some more feedback about it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
