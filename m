Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab3DYIhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:37:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51972 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3DYIhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:37:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 04/32] dmaengine: ste_dma40: Amalgamate DMA source and destination channel numbers
Date: Thu, 25 Apr 2013 10:36:52 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <1366279934-30761-5-git-send-email-lee.jones@linaro.org> <CACRpkdaauDYTdoBHGG9FO4kKqvCYyCrjY8EGWs5gAQWErGW6_A@mail.gmail.com>
In-Reply-To: <CACRpkdaauDYTdoBHGG9FO4kKqvCYyCrjY8EGWs5gAQWErGW6_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304251036.52284.arnd@arndb.de>
X-Provags-ID: V02:K0:3UVr5GwlRR4WzWCalg9q9ZxvoeaC4vD0vx9iIuN+i7E
 weNccrgmeaPd5OZVHjtgGbVv5KPhbJDJ14cRq8PMoZYiGLv6ed
 FXjyO9r+xag0ytm091VKfKe8cfDZ7K8HpBbiwkhBlgLhOs+o9n
 eHr/X3Z9JyN+tNoWGdK44zx7FDPnCNgK7kbZBNCCuGf2EsJPdz
 SeMVtGs/Aj7Avi6RNSGrNLZdHcYz8ZrE6iNsqtJ4Bp82RrHzpC
 84E+4DvwzG+jVZQC8BxOhD+A8qB7qzOC3v427ZhdHLdufCU8yI
 /8MFy5PrK2RXl3aFmj23slFlP3fYjSbbSd8MkADA2d4Rlpz9Fz
 rVHSB9o4VcWwzGypUfIQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 April 2013, Linus Walleij wrote:
> Are we now sacrificing that ability on the altar of simplification?
> 
> I actually think not, but that we should do periph-to-periph transfers
> in some other way, and that the .dir attribute should go away from
> the struct stedma40_chan_cfg as well but I'm not entirely sure.
> Someone else?

The dma-engine core has no support for device-to-device transfers,
and as far as I understand that is neither considered a useful
feature in real life, nor easy to add, so I don't think it matters
much here.

	Arnd
