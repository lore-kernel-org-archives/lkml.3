Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbbAMKoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:44:23 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62737 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbbAMKoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:44:22 -0500
Date: Tue, 13 Jan 2015 18:43:46 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Cc: stefan@agner.ch, kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: clk-vf610: Add clock for UART4 and UART5
Message-ID: <20150113104344.GA19355@dragon>
References: <1420551416-4537-1-git-send-email-bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420551416-4537-1-git-send-email-bhuvanchandra.dv@toradex.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 07:06:56PM +0530, Bhuvanchandra DV wrote:
> Add support for clock gating of UART4 and UART5.
> We use these UART's in a (not yet mainlined)
> device tree.
> 
> Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>

Applied, thanks. 
