Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaE0SH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:07:56 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52692 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaE0SHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:07:55 -0400
Date: Tue, 27 May 2014 11:08:06 -0700
From: Olof Johansson <olof@lixom.net>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: multi_v7_defconfig: Enable Zynq peripheral drivers
Message-ID: <20140527180806.GA26308@quad.lixom.net>
References: <1401210268-20729-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401210268-20729-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 10:04:28AM -0700, Soren Brinkmann wrote:
> A few drivers for Zynq peripherals made it into mainline recently.
> Enable them in the defconfig. The following devices are enabled:
>  - Cadence Macb Ethernet controller
>  - Cadence I2C controller
>  - Arasan SDHCI
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> After quite a while I gave the defonfig a shot again. At first try it
> directly booted my Zynq board to a usable login prompt, and with this
> patch even some peripherals work out of the box.

Applied, thanks!


-Olof
