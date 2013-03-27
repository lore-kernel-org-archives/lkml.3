Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab3C0I2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:28:52 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:59062 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab3C0I2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:28:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130313110630.30040.20743.sendpatchset@w520>
References: <20130313110630.30040.20743.sendpatchset@w520>
Date: Wed, 27 Mar 2013 09:28:49 +0100
Message-ID: <CACRpkdYjWOk---EwS1mQfKbSskxAvV=RbephQxJhg5r44UQQQg@mail.gmail.com>
Subject: Re: [PATCH] gpio: em: Make use of devm functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        horms@verge.net.au, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 12:06 PM, Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@opensource.se>
>
> Update the Emma Mobile GPIO driver to make use of devm
> functions. This simplifies the error handling and makes
> the code more compact.
>
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
>
>  Written on top of:
>  [PATCH] gpio: em: Add Device Tree support

Patch applied, hm git am complains that the patch is broken
on line 137, then when I use patch -p1 < magnus.patch
everything works fine. Weird.

Thanks!
Linus Walleij
