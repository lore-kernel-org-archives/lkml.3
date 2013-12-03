Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3LCLEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:04:35 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:40116 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab3LCLE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:04:29 -0500
Date: Tue, 3 Dec 2013 11:04:22 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <a0393675@ti.com>
Cc: Keerthy <j-keerthy@ti.com>, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, sameo@linux.intel.com,
        grant.likely@linaro.org, lgirdwood@gmail.com, broonie@kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: DT bindings for TPS65218 PMIC
Message-ID: <20131203110422.GO11828@lee--X1>
References: <1386053006-6480-1-git-send-email-j-keerthy@ti.com>
 <1386053006-6480-2-git-send-email-j-keerthy@ti.com>
 <20131203093637.GE11828@lee--X1>
 <529DB7E5.8040702@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <529DB7E5.8040702@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>+- interrupt-controller : Since the tps65218 support several interrupts
> >                                                support(s) (hosts?)
> 
> Yes Supports multiple interrupts from the sub-modules.

I think 'support' should be the plural 'supports'.

<snip>

> >Why aren't you using 'regulator-compatible'?
> 
> I referred tps65217.txt the predecessors and used the compatible.
> I also referred twl-regulator.txt.

That doesn't mean that they are correct/better. ;)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
