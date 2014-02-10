Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaBJLx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:53:28 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35292 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaBJLxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:53:25 -0500
Date: Mon, 10 Feb 2014 11:53:18 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Alessandro Gardich <gremlin@gremlin.it>,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: Re: [PATCH] RFC: MFD: driver for Atmel Microcontroller on iPaq h3xxx
Message-ID: <20140210115318.GD22773@lee--X1>
References: <1391175275-27347-1-git-send-email-linus.walleij@linaro.org>
 <CACRpkdb1LFP45Oy0YJ6DSHriSorvHacH=RRWb4LmZ286LJJX0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdb1LFP45Oy0YJ6DSHriSorvHacH=RRWb4LmZ286LJJX0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This adds a driver for the Atmel Microcontroller found on the
> > iPAQ h3xxx series. This device handles some keys, the
> > touchscreen, and the battery monitoring.
> 
> Any opinions on this driver or should we queue it in MFD as-is?

I have no problem taking this through the MFD tree with Greg's nod.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
