Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab3K3QT3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 11:19:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3K3QT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 11:19:28 -0500
Date: Sat, 30 Nov 2013 08:20:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        pali.rohar@gmail.com, sre@ring0.de, pavel@ucw.cz,
        omar.ramirez@copitl.com, tony@atomide.com, felipe.contreras@gmail.com,
        s-anna@ti.com, nm@ti.com, ohad@wizery.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Staging: tidspbridge: disable driver
Message-ID: <20131130162023.GB15077@kroah.com>
References: <6662B6F95D1C4783A007CAC82A8DA641@ivogl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6662B6F95D1C4783A007CAC82A8DA641@ivogl>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 11:58:23AM +0200, Ivajlo Dimitrov wrote:
> Hi,
> 
> (re-sending in plain text, sorry for the noise)
> 
> commit 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=930ba4a374b96560ef9fde2145cdc454a164ddcc
> disables tidspbridge driver for the reasons it has a security bug and there 
> is no active maintainer.
> I was following the development of that driver for a bit and my impression 
> was that the reason it is
> still in staging is this 
> http://www.spinics.net/lists/linux-omap/msg84115.html . And as dmtimer
> driver is on its way to be merged upstream(or was it already merged?)  I was 
> planning to work on
> tidspbridge driver to fix it and send the patches. I also have a couple of 
> another small patches
> ready to be send.
> However, could you elaborate on the "security bug" so I can try to fix it 
> and send the patch?
> Also, what needs to be done for the tidspdriver to get out of staging as it 
> seems that what I
> though initially is incorrect.

There is also the very long TODO list in drivers/staging/tidspbridge/

What is the progression on that?

thanks,

greg k-h
