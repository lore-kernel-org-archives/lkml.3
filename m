Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaD1Hzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 03:55:52 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:61909 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaD1Hzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 03:55:48 -0400
Date: Mon, 28 Apr 2014 09:55:31 +0200
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
Subject: Re: [PATCH 4/6] drivers: net: cpsw: Enable Annexe F Time sync
Message-ID: <20140428075530.GA8371@netboy>
References: <1398658225-25873-1-git-send-email-george.cherian@ti.com>
 <1398658225-25873-5-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398658225-25873-5-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 09:40:23AM +0530, George Cherian wrote:
> Enable the Annex F Time Sync explicitly for DRA7x and AM4372.
> With this enabled the L2 PTP is working.

L2 works fine without this bit. If this is needed for V3 hardware,
then it should have its own code variant.
 
> while at that rename TS_BIT8 to TS_TTL_NONZERO

Is this bit finally documented for am335x?

Thanks,
Richard

