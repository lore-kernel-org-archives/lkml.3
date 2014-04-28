Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbaD1QTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 12:19:15 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:42380 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbaD1QTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 12:19:10 -0400
Date: Mon, 28 Apr 2014 18:18:56 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: George Cherian <george.cherian@ti.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, dborkman@redhat.com, ast@plumgrid.com,
        tklauser@distanz.ch, mpa@pengutronix.de, bhutchings@solarflare.com,
        zonque@gmail.com, balbi@ti.com, mugunthanvnm@ti.com, t-kristo@ti.com,
        mturquette@linaro.org, linux@arm.linux.org.uk, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, tony@atomide.com,
        bcousson@baylibre.com
Subject: Re: [PATCH 5/6] ARM: AM43xx: clk: Change the cpts ref clock source
 to dpll_core_m5 clk
Message-ID: <20140428161856.GB4266@netboy>
References: <1398658225-25873-1-git-send-email-george.cherian@ti.com>
 <1398658225-25873-6-git-send-email-george.cherian@ti.com>
 <20140428071034.GB4380@netboy>
 <535E4FDC.70306@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535E4FDC.70306@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 06:25:56PM +0530, George Cherian wrote:
> In beagle bone white (AM335x)  CPTS has a choice of 2 clocksource
> -dpll_core_m5_ck
> -dpll_core_m4_ck
> and by default  dpll_core_m5_ck is used. Where as in AM437x the
> default clocksource used is dpll_core_m4_ck .

Is your patch changing the default clock for am335x?

If yes, it shouldn't.
If no, then the patch description should say so.

Thanks,
Richard

 
