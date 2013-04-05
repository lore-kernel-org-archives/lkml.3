Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162017Ab3DEQbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:31:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:61414 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161970Ab3DEQbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:31:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,415,1363158000"; 
   d="scan'208";a="289973885"
Date: Fri, 5 Apr 2013 18:30:56 +0200
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
Subject: Re: [PATCH v10 0/12] Palmas updates
Message-ID: <20130405163056.GN17363@zurbaran>
References: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

On Fri, Mar 22, 2013 at 02:55:10PM +0000, Ian Lartey wrote:
> This patchset adds to the support for the Palmas series of PMIC chips.
> 
> Some of the patches have previously been submitted individually.
> The DT bindings doc has been added first due to comments that it was missing.
> 
> Patches based on linux-next-20130319
Are you expecting all those patches to go through the MFD tree ?
Also, you stil have a few comments from Milo and Stephen to adress. Are you
planning to send a v11 ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
