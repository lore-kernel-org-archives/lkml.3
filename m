Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3GTRub (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 13:50:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab3GTRua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 13:50:30 -0400
Date: Sat, 20 Jul 2013 10:50:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/12] drivers/misc: don't use
 devm_pinctrl_get_select_default() in probe
Message-ID: <20130720175039.GA5697@kroah.com>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
 <1373471889-18107-3-git-send-email-wsa@the-dreams.de>
 <201307110113.58681.arnd@arndb.de>
 <CACRpkdbeFGsvGENOEqAOVSP_GH4cAni+zYXA8eF3CKj1OudesQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbeFGsvGENOEqAOVSP_GH4cAni+zYXA8eF3CKj1OudesQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 07:45:42PM +0200, Linus Walleij wrote:
> On Thu, Jul 11, 2013 at 1:13 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 10 July 2013, Wolfram Sang wrote:
> >> Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
> >> we can rely on device core for setting the default pins. Compile tested only.
> >>
> >> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
> >> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> >
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> I think that the idea is to merge this through respective subsystem.
> Greg, can you take this into your misc-char tree?

Sure, will do.

greg k-h
