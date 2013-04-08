Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936621Ab3DHPv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:51:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:61028 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936499Ab3DHPvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:51:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="319172355"
Date: Mon, 8 Apr 2013 17:51:37 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ian Lartey <ian@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-leds@vger.kernel.org,
        linux-watchdog@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        swarren@wwwdotorg.org, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, rob.herring@calxeda.com,
        rob@landley.net, mturquette@linaro.org, linus.walleij@linaro.org,
        cooloney@gmail.com, sfr@canb.auug.org.au, rpurdie@rpsys.net,
        akpm@linux-foundation.org, wim@iguana.be, lgirdwood@gmail.com,
        gg@slimlogic.co.uk, j-keerthy@ti.com, ldewangan@nvidia.com,
        t-kristo@ti.com
Subject: Re: [PATCH v10 02/12] mfd: palmas: is_palmas_charger needed by
 multiple drivers
Message-ID: <20130408155137.GY24058@zurbaran>
References: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk>
 <1363964122-19201-3-git-send-email-ian@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363964122-19201-3-git-send-email-ian@slimlogic.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

On Fri, Mar 22, 2013 at 02:55:12PM +0000, Ian Lartey wrote:
> is_palmas_charger checks for the presence of charging
> functionality in the device
> 
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> Acked-by: Laxman Dewangani <ldewangan@nvidia.com>
> ---
>  include/linux/mfd/palmas.h |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
I applied this one now, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
