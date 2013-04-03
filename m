Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761472Ab3DCNUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:20:41 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:43331 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760170Ab3DCNUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:20:39 -0400
Date: Wed, 3 Apr 2013 14:20:35 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Jamie Iles <jamie@jamieiles.com>, Barry Song <baohua.song@csr.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: remove mach .init_irq for irqchip_init users
Message-ID: <20130403132035.GA2413@page>
References: <1364503606-10597-1-git-send-email-maxime.ripard@free-electrons.com>
 <1364503606-10597-3-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364503606-10597-3-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 09:46:45PM +0100, Maxime Ripard wrote:
> Now that the arm core code calls irqchip_init, we can remove it from all
> the machines that were using it.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Acked-by: Simon Horman <horms+renesas@verge.net.au>

Acked-by: Jamie Iles <jamie@jamieiles.com>

Thanks Maxime!
