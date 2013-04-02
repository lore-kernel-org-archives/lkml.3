Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502Ab3DBJXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:23:14 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:60117 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761396Ab3DBJXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:23:11 -0400
Date: Tue, 2 Apr 2013 10:23:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH RESEND] ARM: ux500: update V-INTCORE constraints
Message-ID: <20130402092305.GA4375@gmail.com>
References: <20130402084658.GD23065@opensource.wolfsonmicro.com>
 <1364892716-25505-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364892716-25505-1-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Apr 2013, Fabio Baltieri wrote:

> Update V-INTCORE regulator constraints to allow voltage and
> configuration changes from consumer drivers.
> 
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>  arch/arm/mach-ux500/board-mop500-regulators.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

I already have this queued.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
