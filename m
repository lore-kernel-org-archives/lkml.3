Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab3BYOtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:49:12 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:39451 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549Ab3BYOtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:49:11 -0500
Date: Mon, 25 Feb 2013 14:49:04 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, linus.walleij@stericsson.com
Subject: Re: [PATCH 24/35] mfd: ab8500: Remove unnecessary 'struct device'
 declaration
Message-ID: <20130225144904.GM4417@gmail.com>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
 <1360933026-30325-25-git-send-email-lee.jones@linaro.org>
 <201302251433.36121.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201302251433.36121.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2013, Arnd Bergmann wrote:

> On Friday 15 February 2013, Lee Jones wrote:
> > A recent patch saw the device.h include being removed from some other
> > include files and replaced with a 'struct device' declaration instead.
> > However, neither the include nor the declaration is actually required.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  include/linux/mfd/abx500.h |    2 --
> >  1 file changed, 2 deletions(-)
> 
> In my copy of the file, we the declaration
> 
> 
> int ab8500_bm_of_probe(struct device *dev,
>                        struct device_node *np,
>                        struct abx500_bm_data *bm);
> 
> 
> 
> and others that use 'struct device'. C99 requires that a struct is declared
> in advance  before you use it in a function declaration.

Hmm... I wonder why it doesn't complain then?

I'll remove the patch.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
