Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaD1Gzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 02:55:50 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:64270 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaD1Gzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 02:55:47 -0400
Date: Mon, 28 Apr 2014 08:55:29 +0200
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
Subject: Re: [PATCH 1/6] drivers: net: cpts: Remove hardcoded clock name for
 CPTS
Message-ID: <20140428065529.GA4380@netboy>
References: <1398658225-25873-1-git-send-email-george.cherian@ti.com>
 <1398658225-25873-2-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398658225-25873-2-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 09:40:20AM +0530, George Cherian wrote:
> CPTS refclk name is hardcoded, which makes it fail in case of DRA7x
> Remove the hardcoded clock name for CPTS refclk and get the same from DT.

Patch ordering - doesn't this patch depend on patch #2?

Thanks,
Richard
