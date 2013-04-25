Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3DYJOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:14:35 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:59697 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab3DYJOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:14:34 -0400
Date: Thu, 25 Apr 2013 10:14:28 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 09/32] ARM: ux500: Remove unused 'data_width' attributes
 from SDI DMA configs
Message-ID: <20130425091428.GD4623@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-10-git-send-email-lee.jones@linaro.org>
 <CACRpkdbf03ajQaYujGfimHE+hDVjNLycE3J9Q-W-tzN2EX0fkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbf03ajQaYujGfimHE+hDVjNLycE3J9Q-W-tzN2EX0fkQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Linus Walleij wrote:

> On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > DMA configuration data is now allocated in the MMCI driver, so these
> > are just ignored.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> I tried just applying this (since it's pretty stand-alone) but seems to
> be dependent on things not yet in Torvalds tree so lets keep it in this
> series then...

Ideally I'd like to keep them all in the same branch, as it may lead
to confusion/conflicts later down the line (I'm still coding a lot of
this stuff).

Naturally, I'll go with whatever you think is best, but this is my
preference. 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
