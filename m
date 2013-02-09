Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3BIN2L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 08:28:11 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:42531 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3BIN2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 08:28:08 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 7/9] gpiolib: let gpio_chip reference its descriptors
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
In-Reply-To: <CACRpkdZ3L15vbfBGC-SmmGKnt8N_GZGKP92su3aZWQZdPPVR2Q@mail.gmail.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com> <1359822572-26009-9-git-send-email-acourbot@nvidia.com> <CACRpkdZ3L15vbfBGC-SmmGKnt8N_GZGKP92su3aZWQZdPPVR2Q@mail.gmail.com>
Date: Sat, 09 Feb 2013 13:28:03 +0000
Message-Id: <20130209132803.AC8323E30EC@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013 19:00:09 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, Feb 2, 2013 at 5:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> 
> > Add a pointer to the gpio_chip structure that references the array of
> > GPIO descriptors belonging to the chip, and update gpiolib code to use
> > this pointer instead of the global gpio_desc[] array. This is another
> > step towards the removal of the gpio_desc[] global array.
> >
> > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.orh>

Applied, thanks.

g.

