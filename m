Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbaCNQyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:54:18 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57647 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbaCNQyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:54:16 -0400
Date: Fri, 14 Mar 2014 12:54:10 -0400
From: Matt Porter <mporter@linaro.org>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tim Kryger <tim.kryger@linaro.org>
Subject: Re: [PATCH v5 5/5] ARM: dts: add bcm590xx pmu support and enable for
 bcm28155-ap
Message-ID: <20140314165410.GC25092@beef>
References: <1394633237-16837-1-git-send-email-mporter@linaro.org>
 <1394633237-16837-6-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394633237-16837-6-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 10:07:17AM -0400, Matt Porter wrote:
> Add a dtsi to support the BCM590xx PMUs used by the BCM281xx family
> of SoCs. Enable regulators for use with the dwc2 and sdhci on
> bcm28155-ap.
> 
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Signed-off-by: Matt Porter <mporter@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>

Applied to mach-bcm armsoc/for-3.15/dt

-Matt
