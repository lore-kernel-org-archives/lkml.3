Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab3BESAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:00:12 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:59073 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab3BESAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:00:10 -0500
MIME-Version: 1.0
In-Reply-To: <1359822572-26009-9-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
	<1359822572-26009-9-git-send-email-acourbot@nvidia.com>
Date: Tue, 5 Feb 2013 19:00:09 +0100
Message-ID: <CACRpkdZ3L15vbfBGC-SmmGKnt8N_GZGKP92su3aZWQZdPPVR2Q@mail.gmail.com>
Subject: Re: [PATCH 7/9] gpiolib: let gpio_chip reference its descriptors
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 5:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Add a pointer to the gpio_chip structure that references the array of
> GPIO descriptors belonging to the chip, and update gpiolib code to use
> this pointer instead of the global gpio_desc[] array. This is another
> step towards the removal of the gpio_desc[] global array.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.orh>

Yours,
Linus Walleij
