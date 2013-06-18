Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab3FRJWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:22:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:21479 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654Ab3FRJWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:22:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,887,1363158000"; 
   d="scan'208";a="355270430"
Date: Tue, 18 Jun 2013 11:16:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] mfd: tps65910: Fix crash in i2c_driver .probe
Message-ID: <20130618091610.GG7161@zurbaran>
References: <1371491257-23791-1-git-send-email-ttynkkynen@nvidia.com>
 <1371491257-23791-2-git-send-email-ttynkkynen@nvidia.com>
 <51BF5281.2030105@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BF5281.2030105@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 12:16:33PM -0600, Stephen Warren wrote:
> On 06/17/2013 11:47 AM, Tuomas Tynkkynen wrote:
> > Commit "i2c: core: make it possible to match a pure device tree driver"
> > changed semantics of the i2c probing for device tree devices.
> > Device tree probed devices now get a NULL i2c_device_id pointer.
> > This caused kernel panics due to NULL dereference.
> 
> Tested-by: Stephen Warren <swarren@nvidia.com>
> 
> (although I imagine I'd need to retest if there was a v2 to address my
> previous comments)
I would prefer seeing a v2, especially to address the pmic_plat_data
overwriting issue.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
