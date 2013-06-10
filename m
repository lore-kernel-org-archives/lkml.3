Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab3FJIE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:04:28 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:52109 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3FJIE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:04:26 -0400
Date: Mon, 10 Jun 2013 09:04:20 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "J, KEERTHY" <j-keerthy@ti.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: Re: [PATCH] ARM: dts: add dtsi for palmas
Message-ID: <20130610080420.GC24958@gmail.com>
References: <1370604504-32310-1-git-send-email-j-keerthy@ti.com>
 <51B23AD5.8060006@wwwdotorg.org>
 <DC88CAD03C0052499C1907B327FC63229EAA39@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DC88CAD03C0052499C1907B327FC63229EAA39@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Totally agree to all the above concerns. So can we have a custom .dtsi file
> for a board+pmic combination? Or have only the required properties over ridden
> in the board file?

The common approach is to only apply nodes and node properties to the
.dtsi files which are appropriate for _all_ platforms which include
them. Anything that is only relevant to a sub-set of boards should be
in a higher ranking .dtsi file and finally, any settings which are
board specific should be in the board's .dts file.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
