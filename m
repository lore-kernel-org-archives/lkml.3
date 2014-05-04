Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbaEDQYo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:24:44 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:51742 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbaEDQYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 12:24:40 -0400
Date: Sun, 4 May 2014 18:24:22 +0200
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
Subject: Re: [PATCH v2 0/6] Add CPTS support for AM437x
Message-ID: <20140504162422.GA28908@netboy>
References: <1399012324-20737-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399012324-20737-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 12:01:58PM +0530, George Cherian wrote:
> The series adds CPTS support for AM4372.
> 
> Patch 1 - DT changes w.r.t clock changes for AM33xx.
> Patch 2 - CPTS clock name harcoding in the driver is removed. 
> 	  Easier to pass the clock name from dt rather than hardcoding in driver.
> 	  Also in prepration for DRA7x CPTS support.
> Patch 3 - Enable the CPTS support for both DRA7x and AM4372 in the driver.
> Patch 4 - Enable the Annexe F for L2 PTP for AM437x and DRA7x.
> Patch 5 - Change the default clocksource to dpll_core_m5 
> Patch 6 - DT changes for AM4372.
> 
> 
> v1 -> v2
> 	Patch 1 and 2 Re-ordering.
> 	Seperate TS_BITS define for Hw version V2 and V3

Acked-by: Richard Cochran <richardcochran@gmail.com>
