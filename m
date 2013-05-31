Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab3EaXl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 19:41:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:52670 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab3EaXlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 19:41:20 -0400
Message-ID: <1370043630.3928.166.camel@pasglop>
Subject: Re: [PATCH v2] can: flexcan: remove HAVE_CAN_FLEXCAN Kconfig symbol
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        U Bhaskar-B22300 <B22300@freescale.com>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Date: Sat, 01 Jun 2013 09:40:30 +1000
In-Reply-To: <519A4A00.8000109@pengutronix.de>
References: <1368781157-4646-1-git-send-email-mkl@pengutronix.de>
	 <20130517090949.GI8607@S2101-09.ap.freescale.net>
	 <519A4A00.8000109@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-20 at 18:06 +0200, Marc Kleine-Budde wrote:
> On 05/17/2013 11:09 AM, Shawn Guo wrote:
> > On Fri, May 17, 2013 at 10:59:17AM +0200, Marc Kleine-Budde wrote:
> >> This patch removes the Kconfig symbol HAVE_CAN_FLEXCAN from arch/{arm,powerpc}
> >> and allowing compilation unconditionally on all arm and powerpc platforms.
> >>
> >> This brings a bigger compile time coverage and removes the following dependency
> >> warning found by Arnd Bergmann:
> >>
> >>     warning: (SOC_IMX28 && SOC_IMX25 && SOC_IMX35 && IMX_HAVE_PLATFORM_FLEXCAN &&
> >>         SOC_IMX53 && SOC_IMX6Q) selects HAVE_CAN_FLEXCAN
> >>     which has unmet direct dependencies (NET && CAN && CAN_DEV)
> >>
> >> Cc: Arnd Bergmann <arnd@arndb.de>
> >> Cc: Shawn Guo <shawn.guo@linaro.org>
> > 
> > Acked-by: Shawn Guo <shawn.guo@linaro.org>
> 
> Thanks.
> 
> An Acked-by by the powerpc people would be fine. However, if nobody
> doesn't object, I'm sending this patch via linux-can and net-next upstream.

Sorry, missed it, if it's still out there, add my

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.

