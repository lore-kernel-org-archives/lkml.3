Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964921Ab3HHMcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 08:32:12 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:64521 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964844Ab3HHMcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 08:32:09 -0400
Date: Thu, 8 Aug 2013 13:32:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Bill Huang <bilhuang@nvidia.com>
Cc: sameo@linux.intel.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, broonie@linaro.org, nm@ti.com, j-keerthy@ti.com,
        grant.likely@linaro.org, ian@slimlogic.co.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mallikarjun Kasoju <mkasoju@nvidia.com>
Subject: Re: [PATCH RESEND v2 1/1] mfd: palmas: Add power off control
Message-ID: <20130808123203.GD14515@lee--X1>
References: <1375962305-7438-1-git-send-email-bilhuang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375962305-7438-1-git-send-email-bilhuang@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Aug 2013, Bill Huang wrote:

> Hook up "pm_power_off" to palmas power off routine if there is DT
> property "ti,system-power-controller" defined, so platform which is
> powered by this regulator can be powered off properly.
> 
> Signed-off-by: Mallikarjun Kasoju <mkasoju@nvidia.com>
> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> ---
>  .../devicetree/bindings/regulator/palmas-pmic.txt  |    5 +++
>  drivers/mfd/palmas.c                               |   33 ++++++++++++++++++--
>  include/linux/mfd/palmas.h                         |    1 +
>  3 files changed, 37 insertions(+), 2 deletions(-)

Was a clear conclusion reached between Nishanth and yourself?

As he has strong opinions on this I'd ideally like his Ack before
applying the patch.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
