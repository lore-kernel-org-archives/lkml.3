Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaAFLH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:07:58 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35585 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaAFLH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:07:56 -0500
Date: Mon, 6 Jan 2014 11:07:50 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 1/2] gpio: lp3943: Remove redundant of_match_ptr helper
Message-ID: <20140106110750.GO23772@lee--X1>
References: <1387621661-22128-1-git-send-email-sachin.kamat@linaro.org>
 <CACRpkdb+NQOZXD2iHco+5UoFAt0abc8teFvZV0TayxXMRUZRNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdb+NQOZXD2iHco+5UoFAt0abc8teFvZV0TayxXMRUZRNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Jan 2014, Linus Walleij wrote:

> On Sat, Dec 21, 2013 at 11:27 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> 
> > 'lp3943_gpio_of_match' is always compiled in. Hence the
> > helper macro is not needed.
> >
> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> > ---
> >  drivers/gpio/gpio-lp3943.c |    2 +-
> 
> This driver is merged into the MFD tree, you need Lee or
> Sam to apply it.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
