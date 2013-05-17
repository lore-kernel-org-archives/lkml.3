Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3EQCEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 22:04:00 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:2992 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447Ab3EQCD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 22:03:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 17 May 2013 10:03:52 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, <linux-can@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Sascha Hauer <s.hauer@pengutronix.de>,
        Kumar Gala <galak@kernel.crashing.org>,
        U Bhaskar-B22300 <B22300@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] can: flexcan: allow compilation on arm and powerpc
Message-ID: <20130517020351.GE3893@S2101-09.ap.freescale.net>
References: <1368711756-22324-1-git-send-email-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1368711756-22324-1-git-send-email-mkl@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On Thu, May 16, 2013 at 03:42:36PM +0200, Marc Kleine-Budde wrote:
> This patch removes the Kconfig symbols HAVE_CAN_FLEXCAN and
> IMX_HAVE_PLATFORM_FLEXCAN from arch/{arm,powerpc} and allowing compilation on
> all arm and powerpc platforms.

I'm generally fine with the approach.  But with Kconfig symbol
IMX_HAVE_PLATFORM_FLEXCAN removed, how does the build of
platform-flexcan.o work?

arch/arm/mach-imx/devices/Makefile:obj-$(CONFIG_IMX_HAVE_PLATFORM_FLEXCAN) += platform-flexcan.o

Shawn

