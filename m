Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3HPPVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:21:21 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:38401 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab3HPPVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:21:18 -0400
MIME-Version: 1.0
In-Reply-To: <1376490038-32382-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1376490038-32382-1-git-send-email-ricardo.ribalda@gmail.com>
Date: Fri, 16 Aug 2013 17:21:18 +0200
Message-ID: <CACRpkdbOPL7K2yc_zAo0-b-Y0mXCRXJfc7YYDhcb0K3uj76BBQ@mail.gmail.com>
Subject: Re: [PATCH] gpio-pca953x: Fix read for chips with more than 8 gpios
From: Linus Walleij <linus.walleij@linaro.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Ruder <andy@aeruder.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 4:20 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:

> pca953x_read_single returns ONLY the value of the 8 inputs of the
> same bank.
>
> off can have a value from 0 to 15, therefore we have to find the
> offset of that gpio within that bank.
>
> Without this patch gpios 8-15 will always be read as zero.
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Nice! But it turns out I already had an identical patch by
Andrew Ruder acked by Gregory Clement in my patch queue.

Yours,
Linus Walleij
