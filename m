Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbbANN1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:27:43 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:57190 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbbANN1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:27:42 -0500
MIME-Version: 1.0
In-Reply-To: <1421079149-2236-1-git-send-email-johan@kernel.org>
References: <1421079149-2236-1-git-send-email-johan@kernel.org>
Date: Wed, 14 Jan 2015 14:27:41 +0100
Message-ID: <CACRpkdZwbigvBE0X9zwAWaaPp4Nt2gHxY+7nrKX5KTOy7J97RA@mail.gmail.com>
Subject: Re: [PATCH 0/6] gpio: fix gpio_chip add and remove
From: Linus Walleij <linus.walleij@linaro.org>
To: Johan Hovold <johan@kernel.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 5:12 PM, Johan Hovold <johan@kernel.org> wrote:

> This series fix a few issues with gpiochip_add and gpiochip_remove.
>
> The gpio-chip removal paths have probably not been exercised much, and
> there are further issues here that I'm working on fixing in order better
> support hot-plugging of gpio chips. I believe these patches should go
> into 3.19 meanwhile.

GOOD STUFF!
All six applied for fixes.

Yours,
Linus Walleij
