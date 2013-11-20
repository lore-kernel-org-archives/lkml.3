Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3KTNiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:38:22 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:50377 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3KTNiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:38:19 -0500
MIME-Version: 1.0
In-Reply-To: <20131120002326.27342.83787.sendpatchset@w520>
References: <20131120002259.27342.35575.sendpatchset@w520>
	<20131120002326.27342.83787.sendpatchset@w520>
Date: Wed, 20 Nov 2013 14:38:18 +0100
Message-ID: <CACRpkdayj-4w-X0YQYZP_-Mib18bB7Tc-U+xwD9-09KwVdZdbg@mail.gmail.com>
Subject: Re: [PATCH 03/05] gpio: em: Setup gpiochip->dev
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 1:23 AM, Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@opensource.se>
>
> Make sure gpio_chip->dev is setup so of_gpiochip_add()
> will work as expected.
>
> Signed-off-by: Magnus Damm <damm@opensource.se>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Patch applied.

Yours,
Linus Walleij
