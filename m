Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbaAURPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:15:37 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:63871 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaAURPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:15:33 -0500
Date: Tue, 21 Jan 2014 17:15:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] mfd: tc3589x: reform device tree probing
Message-ID: <20140121171527.GD27111@lee--X1>
References: <1381871803-22796-1-git-send-email-linus.walleij@linaro.org>
 <CACRpkdYYN2hDsRw2xu0kv0zGDBGENFoqS915qCok28ZQhBOygg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYYN2hDsRw2xu0kv0zGDBGENFoqS915qCok28ZQhBOygg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This changes the following mechanisms in the TC3589x device tree
> > probing path:
> >
> > - Use the .of_match_table in struct device_driver to match the
> >   device in the device tree.
> > - Add matches for the proper compatible strings "toshiba,..."
> >   and all sub-variants, just as is done for the .id matches.
> > - Move over all the allocation of platform data etc to the
> >   tc3589x_of_probe() function and follow the pattern of passing
> >   a platform data pointer back, or an error pointer on error,
> >   as found in the STMPE driver.
> > - Match the new (proper) compatible strings for the GPIO and
> >   keypad MFD cells.
> > - Use of_device_is_compatible() rather than just !strcmp()
> >   to discover which cells to instantiate.
> >
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Waiting for this patch to go in as well... I can resend the
> entire set of it helps.

If you do so, I'll endeavour to get them sent during -rc1.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
