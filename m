Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaEAGnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:43:11 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:56438 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbaEAGnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:43:09 -0400
Message-ID: <1398926587.28080.5.camel@x220>
Subject: Re: [PATCH v2 01/12] ARM: imx/mxs defconfigs: add MTD_SPI_NOR (new
 dependency for M25P80)
From: Paul Bolle <pebolle@tiscali.nl>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>, Marek Vasut <marex@denx.de>,
        linux-mtd@lists.infradead.org, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 01 May 2014 08:43:07 +0200
In-Reply-To: <1398925607-7482-2-git-send-email-computersforpeace@gmail.com>
References: <1398925607-7482-1-git-send-email-computersforpeace@gmail.com>
	 <1398925607-7482-2-git-send-email-computersforpeace@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 May 2014 06:43:08.0241 (UTC) FILETIME=[9CD56C10:01CF6508]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 23:26 -0700, Brian Norris wrote:
> These defconfigs contain the CONFIG_M25P80 symbol, which is now

That's a typo: use "the MTD_M25P80 symbol" (but only if you need to
resend anyway, I'd say; the same typo can be found in the subject too).

> dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to satisfy
> the new dependency.
> 
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Marek Vasut <marex@denx.de>


Paul Bolle

