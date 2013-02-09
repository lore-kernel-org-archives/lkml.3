Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3BIKKP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 05:10:15 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44479 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab3BIKKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 05:10:10 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 5/9] gpiolib: use gpio_chips list in gpiochip_find_base
To: Alex Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <5111E093.4060600@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com> <1359822572-26009-7-git-send-email-acourbot@nvidia.com> <CACRpkdYT4p8uez8DHTSsjKFb=KmWbtCXJQtyXLAJkCC7fKaErw@mail.gmail.com> <5111E093.4060600@nvidia.com>
Date: Sat, 09 Feb 2013 09:47:53 +0000
Message-Id: <20130209094753.555F03E2C66@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2013 13:48:19 +0900, Alex Courbot <acourbot@nvidia.com> wrote:
> On 02/06/2013 02:21 AM, Linus Walleij wrote:
> > This looks like it is preserving this userspace-sensitive semantic
> > so that dynamically added chips will still get the same assigned
> > numbers.
> 
> It does (it should, at least), the assigned ranges should be strictly 
> identical to the previous version. While testing I also made sure all 
> chips had the same GPIO range.
> 
> > But I want some guarantees, so state clearly in the commit
> > that any dynamically assigned chip will get the same base
> > address after this change as it got before it, and please take
> > this opportunity to add a comment stating that this search
> > method is vital for userspace ABIs, and must be preserved.
> 
> Done. I will take the blame if something goes wrong. :)

Applied, thanks

g.

