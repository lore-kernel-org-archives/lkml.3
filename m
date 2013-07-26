Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341Ab3GZJMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:12:33 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:40573 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758320Ab3GZJM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:12:28 -0400
Message-ID: <1374829895.1956.39.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH 1/7] usb: phy: msm: Move mach dependent code to platform
 data
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: David Brown <davidb@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Walker <dwalker@fifo99.com>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 26 Jul 2013 12:11:35 +0300
In-Reply-To: <20130724155505.GA26371@codeaurora.org>
References: <1372087664-26396-1-git-send-email-iivanov@mm-sol.com>
	 <1372087664-26396-2-git-send-email-iivanov@mm-sol.com>
	 <20130724155505.GA26371@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 08:55 -0700, David Brown wrote:
> On Mon, Jun 24, 2013 at 06:27:38PM +0300, Ivan T. Ivanov wrote:
> >From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> >
> >This patch fix compilation error and is an intermediate step
> >before the addition of DeviceTree support for newer targets.
> >Fix suggested here: https://lkml.org/lkml/2013/6/19/381
> >
> >Cc: David Brown <davidb@codeaurora.org>
> >Cc: Daniel Walker <dwalker@fifo99.com>
> >Cc: Bryan Huntsman <bryanh@codeaurora.org>
> >Cc: Russell King <linux@arm.linux.org.uk>
> >Cc: Felipe Balbi <balbi@ti.com>
> >Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >Cc: Stephen Boyd <sboyd@codeaurora.org>
> >Cc: linux-arm-kernel@lists.infradead.org
> >Cc: linux-kernel@vger.kernel.org
> >
> >Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> >---
> > arch/arm/mach-msm/board-msm7x30.c |   35 +++++++++++++++++++++++
> > arch/arm/mach-msm/board-qsd8x50.c |   34 +++++++++++++++++++++++
> > drivers/usb/phy/phy-msm-usb.c     |   55 ++++++++++---------------------------
> > include/linux/usb/msm_hsusb.h     |    2 ++
> > 4 files changed, 85 insertions(+), 41 deletions(-)
> 
> Acked-by: David Brown <davidb@codeaurora.org>
> 

Thank you David, but I am afraid that I have screwup this patch. It
doesn't build fine. I will send second version.
Sorry. Ivan

