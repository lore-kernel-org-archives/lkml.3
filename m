Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300Ab3GaJ4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:56:44 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:44641 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab3GaJ4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:56:42 -0400
Date: Wed, 31 Jul 2013 10:56:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Bill Huang <bilhuang@nvidia.com>
Cc: sameo@linux.intel.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, broonie@linaro.org, nm@ti.com, j-keerthy@ti.com,
        grant.likely@linaro.org, ian@slimlogic.co.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mallikarjun Kasoju <mkasoju@nvidia.com>
Subject: Re: [PATCH 1/1] mfd: palmas: Add power off control
Message-ID: <20130731095636.GB13298@lee--X1>
References: <1375185957-28212-1-git-send-email-bilhuang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375185957-28212-1-git-send-email-bilhuang@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jul 2013, Bill Huang wrote:

> Hook up "pm_power_off" to palmas power off routine if there is DT
> property "ti,system-power-controller" defined, so platform which is
> powered by this regulator can be powered off properly.
> 
> Based on work by:
> Mallikarjun Kasoju <mkasoju@nvidia.com>
> 
> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> cc: Mallikarjun Kasoju <mkasoju@nvidia.com>

Please put the 'Cc:' (not 'cc:') above the SoBs, then drop the "Based
on work by:" and replace with:

Signed-off-by: Mallikarjun Kasoju <mkasoju@nvidia.com>
Signed-off-by: Bill Huang <bilhuang@nvidia.com>

This insinuates that the original patch was crated by Mallikarjun.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
