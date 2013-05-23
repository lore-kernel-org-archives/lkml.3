Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341Ab3EWO6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:58:50 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:45455 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360Ab3EWO6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:58:49 -0400
Date: Thu, 23 May 2013 16:58:35 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@ardb.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Oliver Schinagl <oliver@schinagl.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Message-ID: <20130523145835.GI8595@lukather>
References: <1368797744-13737-1-git-send-email-oliver+list@schinagl.nl>
 <1368797744-13737-2-git-send-email-oliver+list@schinagl.nl>
 <CACRpkdaWADjy1YZXTcRaXU+ZsS6_pG0hojQdnz=qeTgyVY7_Ww@mail.gmail.com>
 <519DCEE9.6070208@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519DCEE9.6070208@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 10:10:17AM +0200, Oliver Schinagl wrote:
> Then, i'm not sure if the driver is the best for this to be loaded?
> Maxime, what do you think? Personally I would feel more in having
> this in the mach-sunxi/core.c bit, but then again, this is currently
> a module and wouldn't be useful to have there. Maxime is far more
> knowledgeable to answer that.

Hmmm, I don't understand what you mean here. Could you explain what you
have in mind?

Thanks,
Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
