Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab3AXJiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:38:08 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:33624 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab3AXJiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:38:01 -0500
Date: Thu, 24 Jan 2013 09:37:54 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 1/1] ARM: ux500: Disable Power Supply and Battery
 Management by default
Message-ID: <20130124093754.GR15873@gmail.com>
References: <1358175470-5041-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdYydqJ+BVsh7P411zCod+83f2pVV5tPsKfoWPYUnOVpDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYydqJ+BVsh7P411zCod+83f2pVV5tPsKfoWPYUnOVpDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jan 2013, Linus Walleij wrote:

> On Mon, Jan 14, 2013 at 3:57 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > The AB8500 Battery Management collection of drivers are more than a
> > little bit broken. There is lots of work still on-going in that area
> > and it's improving day by day; however, it's not ready to be enabled
> > by default just yet.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Is this going for fixes (v3.8?)

Sorry, I thought I answer this, but clearly I didn't.

Can you take this into the -rcs please? It's preventing from a few of
the platforms from booting.

> For v3.9 I think you've submitted a whole lot of patches
> actually fixing it up?
> 
> Anyway: Acked-by: Linus Walleij <linus.walleij@linaro.org>
> since you certainly know the status of this driver better than
> me.
> 
> Yours,
> Linus Walleij

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
