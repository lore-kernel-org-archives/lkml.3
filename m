Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab3AUOCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:02:48 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:36962 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab3AUOCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:02:47 -0500
Date: Mon, 21 Jan 2013 14:02:41 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 1/1] ARM: ux500: Disable Power Supply and Battery
 Management by default
Message-ID: <20130121140241.GA6857@gmail.com>
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

> > The AB8500 Battery Management collection of drivers are more than a
> > little bit broken. There is lots of work still on-going in that area
> > and it's improving day by day; however, it's not ready to be enabled
> > by default just yet.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Is this going for fixes (v3.8?)
> 
> For v3.9 I think you've submitted a whole lot of patches
> actually fixing it up?

I did submit a bunch of fixes, but more are required.

> Anyway: Acked-by: Linus Walleij <linus.walleij@linaro.org>
> since you certainly know the status of this driver better than
> me.

Thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
