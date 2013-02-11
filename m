Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab3BKOcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:32:01 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:63886 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab3BKOcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:32:00 -0500
MIME-Version: 1.0
In-Reply-To: <1360406062-14982-1-git-send-email-grant.likely@secretlab.ca>
References: <1360406062-14982-1-git-send-email-grant.likely@secretlab.ca>
Date: Mon, 11 Feb 2013 15:31:45 +0100
Message-ID: <CACRpkdYBQDCuyff1cVaG2p_AaFvZ-sEX0B=j=Y4nsko8UDChHA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Fix locking on gpio debugfs files
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 9, 2013 at 11:34 AM, Grant Likely <grant.likely@secretlab.ca> wrote:

> The debugfs files really need to hold the gpiolib spinlock before
> accessing the list. Otherwise chip addition/removal will cause an oops.
>
> Cc: Alexandre Courbot <acourbot@nvidia.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

> I've also got a draft patch that turns gpio chips into first-class
> kobjects which means we can do proper reference counting on them and
> prevent the structure from actually disappearing while other drivers
> still hold references.

Thank you for doing this!

Yours,
Linus Walleij
