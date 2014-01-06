Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaAFMPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:15:22 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64770 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaAFMPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:15:20 -0500
Date: Mon, 6 Jan 2014 12:15:13 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 1/2] gpio: lp3943: Remove redundant of_match_ptr helper
Message-ID: <20140106121513.GF30156@lee--X1>
References: <1387621661-22128-1-git-send-email-sachin.kamat@linaro.org>
 <CACRpkdb+NQOZXD2iHco+5UoFAt0abc8teFvZV0TayxXMRUZRNw@mail.gmail.com>
 <20140106110750.GO23772@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140106110750.GO23772@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Jan 2014, Lee Jones wrote:

> On Thu, 02 Jan 2014, Linus Walleij wrote:
> 
> > On Sat, Dec 21, 2013 at 11:27 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> > 
> > > 'lp3943_gpio_of_match' is always compiled in. Hence the
> > > helper macro is not needed.
> > >
> > > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> > > ---
> > >  drivers/gpio/gpio-lp3943.c |    2 +-
> > 
> > This driver is merged into the MFD tree, you need Lee or
> > Sam to apply it.
> > 
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Applied, thanks.

Whoops, jumped ahead of the gun there. I don't have this in my inbox.

Sachin, can you send again with Linus' Ack please?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
