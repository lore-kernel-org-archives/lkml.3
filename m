Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3A1XBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 18:01:03 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:64335 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3A1XBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 18:01:01 -0500
Date: Mon, 28 Jan 2013 15:00:59 -0800
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, arm@kernel.org
Subject: Re: [PATCH 5/5] ARM: ux500: select the DB8540 pin controller
Message-ID: <20130128230059.GE7789@quad.lixom.net>
References: <1359381151-28127-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359381151-28127-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 02:52:31PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> The pin controller is an inherent part of the SoC, without
> it the system will not boot, thus it needs to be selected
> from Kconfig.
> 
> Cc: arm@kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Requesting ACK from ARM SoC on this patch.

Acked-by: Olof Johansson <olof@lixom.net>

... but I wonder if this is growing out of hand. Since they will always
be selected (and required) for UX500_SOC_DB8500, why not just make them
silent options that default to y with that as a depend?


-Olof
