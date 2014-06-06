Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaFFMnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:43:37 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:53797 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaFFMnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:43:35 -0400
Date: Fri, 6 Jun 2014 13:43:28 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <a0393675@ti.com>
Cc: Keerthy <j-keerthy@ti.com>, linux-omap@vger.kernel.org,
        lgirdwood@gmail.com, broonie@kernel.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Subject: Re: [PATCH 0/9] mfd: tps65917: Add support for for TPS65917 PMIC
Message-ID: <20140606124328.GR24240@lee--X1>
References: <1401272423-25761-1-git-send-email-j-keerthy@ti.com>
 <53919EF7.2000904@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53919EF7.2000904@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Mark/Lee Jones,
> 
> On Wednesday 28 May 2014 03:50 PM, Keerthy wrote:
> >The TPS65917 chip is a power management IC for Portable Navigation Systems
> >and Tablet Computing devices. It contains the following components:
> >
> >  - Regulators.
> >  - GPADC.
> >  - Over Temperature warning and Shut down.
> >
> >This patch series adds support for TPS65917 mfd device. At this time only
> >the regulator functionality is made available.
> >
> >The closest drivers are PALMAS series drivers. Hence adapted palmas mfd
> >driver to support the tps65917 PMIC.
> >
> >The register set for SMPSs and LDOs are changed and the ramp delay support
> >is also changed. Bit-field defenitions are changed.
> >Hence added driver data structures for mfd and regulator drivers
> >for palmas and added support for tps65917.
> >
> >The patches are boot tested on DRA72-EVM.
> >The patches are boot tested on OMAP5-UEVM board.
> 
> A gentle ping on this rework.

There's no point in pinging on any patch during the merge-window.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
