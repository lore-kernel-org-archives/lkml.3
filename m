Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3EZRe5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 13:34:57 -0400
Received: from void.printf.net ([89.145.121.20]:59339 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab3EZRe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 13:34:56 -0400
From: Chris Ball <cjb@laptop.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] mmc: atmel-mci: convert to dma_request_slave_channel_compat()
References: <517F7B6F.4070907@atmel.com>
	<1368180314-13665-1-git-send-email-nicolas.ferre@atmel.com>
Date: Sun, 26 May 2013 13:34:50 -0400
In-Reply-To: <1368180314-13665-1-git-send-email-nicolas.ferre@atmel.com>
	(Nicolas Ferre's message of "Fri, 10 May 2013 12:05:14 +0200")
Message-ID: <871u8tmypx.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Fri, May 10 2013, Nicolas Ferre wrote:
> From: Ludovic Desroches <ludovic.desroches@atmel.com>
>
> Use generic DMA DT helper. Platforms booting with or without DT populated are
> both supported.
>
> Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Hi Chris,
>
> This patch is part of a series by Ludovic and is adding the generic slave
> DMA request channel function, as we now have the support for DMA bindings.
>
> This is the only patch of the series that should go through your tree. And it
> seems that my little reminder didn't catch your attention in time for 3.10 merge
> window but I still hope that we can make it for 3.10-final... It is also true
> that we didn't put you in copy of the original message and that the subject
> line was somehow malformed ;-)
>
> Here is the Linux arm kernel patchwork reference of previous discussion:
> https://patchwork.kernel.org/patch/2463641/

Thanks, I'm sorry for the delay.  This is in mmc-next now, I'll send
it to Linus for the next -rc.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
