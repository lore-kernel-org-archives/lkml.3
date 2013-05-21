Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab3EUHbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:31:38 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:60705 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab3EUHbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:31:37 -0400
Date: Tue, 21 May 2013 09:31:32 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Tony Prisk <linux@prisktech.co.nz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pinctrl: Don't override the error code in probe
 error handling
Message-ID: <20130521073132.GA3059@lukather>
References: <1368943117.3455.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368943117.3455.4.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Sun, May 19, 2013 at 01:58:37PM +0800, Axel Lin wrote:
> Otherwise, we return 0 in probe error paths when gpiochip_remove() returns 0.
> Also show error message if gpiochip_remove() fails.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: Tony Prisk <linux@prisktech.co.nz>

For the sunxi part
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
