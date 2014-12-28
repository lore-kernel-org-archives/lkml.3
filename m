Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaL2Dcp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 22:32:45 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:59654 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaL2Dco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 22:32:44 -0500
X-Auth-Info: xnUy4xm+iYEBBZeuo3VgtWcwiUdsqA29J2IaXTfNdf0=
From: Marek Vasut <marex@denx.de>
To: Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH V2] clk: mxs: Fix invalid 32-bit access to frac registers
Date: Sun, 28 Dec 2014 19:30:17 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: mturquette@linaro.org, festevam@gmail.com, shawn.guo@linaro.org,
        harald@ccbib.org, kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1419762402-4548-1-git-send-email-stefan.wahren@i2se.com>
In-Reply-To: <1419762402-4548-1-git-send-email-stefan.wahren@i2se.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201412281930.17676.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 28, 2014 at 11:26:42 AM, Stefan Wahren wrote:
> According to i.MX23 and i.MX28 reference manual the fractional
> clock control registers must be addressed by byte instructions.
> 
> This patch fixes the erroneous 32-bit access to these registers
> and extends the comment in the init functions.
> 
> Btw the imx23 init now uses a R-M-W sequence just like imx28 init
> to avoid any clock glitches.
> 
> The changes has been tested only with a i.MX28 board, because i don't
> have access to an i.MX23 board.
> 
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>

I don't see a problem,

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
