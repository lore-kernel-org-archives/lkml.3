Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab3LCP5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:57:52 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:58558 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab3LCP5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:57:51 -0500
Date: Tue, 3 Dec 2013 15:57:43 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mfd: ab8500: delete all GPIO platform data instances
Message-ID: <20131203155743.GH28159@lee--X1>
References: <1386082234-18919-1-git-send-email-linus.walleij@linaro.org>
 <20131203155511.GG28159@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131203155511.GG28159@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Dec 2013, Lee Jones wrote:

> On Tue, 03 Dec 2013, Linus Walleij wrote:
> 
> > This deletes all instances where the AB8500 GPIO platform
> > data is passed around. It is completely unused in the kernel
> > now, so it does not hurt anyone.
> > 
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > ---
> > Sam, Lee: requesting an ACK to take this through either the
> > pinctrl tree or the ARM SoC tree if I build up more of these
> > pdata removal patches for abx500.
> 
> If it's completely unused, why does it matter which tree it goes
> through?

Ah, I see, sorry!

Yes, you can have your Ack, but any MFD patches which go through must
conform to the MFD rules, so get that $SUBJECT line capitalised. ;)

After $SUBJECT line conformity:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
