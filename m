Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaLPCqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:46:47 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34757 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaLPCqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:46:42 -0500
Date: Tue, 16 Dec 2014 10:46:07 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: kernel@pengutronix.de, jingchang.lu@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: pllv3: add shift for frequency multiplier
Message-ID: <20141216024605.GX2411@dragon>
References: <1417539582-11387-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417539582-11387-1-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 05:59:42PM +0100, Stefan Agner wrote:
> Add shift capabilties for the frequency multiplier (DIV_SELECT) to
> support Vybrid's USB PLL oddity. The PLL3 and PLL7 are the only
> PLL control registers which have the DIV_SELECT bit shifted by
> one. Be aware, there are known documentation errors in the
> reference manual too.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Applied, thanks.
