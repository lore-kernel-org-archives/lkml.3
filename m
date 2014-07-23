Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbaGWPgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:36:48 -0400
Received: from mail-oi0-f54.google.com ([209.85.218.54]:63829 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758318AbaGWPgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:36:46 -0400
MIME-Version: 1.0
In-Reply-To: <1406013463-19218-2-git-send-email-acourbot@nvidia.com>
References: <1406013463-19218-1-git-send-email-acourbot@nvidia.com>
	<1406013463-19218-2-git-send-email-acourbot@nvidia.com>
Date: Wed, 23 Jul 2014 17:36:45 +0200
Message-ID: <CACRpkdaewsVMUtPs1Uz9mxRAQ8H5ZPa5Y2uLBP4Sz3L2iRYiaA@mail.gmail.com>
Subject: Re: [PATCH 1/5] gpio: remove export of private of_get_named_gpio_flags()
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 9:17 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> of_get_named_gpio_flags() has been made gpiolib-private by commit
> f01d907582, but its EXPORT statement has not been removed. Fix this.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Patch applied.

Yours,
Linus Walleij
