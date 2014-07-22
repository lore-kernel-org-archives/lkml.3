Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbaGVVvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:51:43 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:62527 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaGVVvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:51:42 -0400
MIME-Version: 1.0
In-Reply-To: <1405157629-10550-1-git-send-email-linus.walleij@linaro.org>
References: <1405157629-10550-1-git-send-email-linus.walleij@linaro.org>
Date: Tue, 22 Jul 2014 23:51:41 +0200
Message-ID: <CACRpkdYL1RsTJTrm7k8cssfVPB=Fr_6UJQ0rg98t-uW9n6OSZA@mail.gmail.com>
Subject: Re: [PATCH] power: add driver for battery reading on iPaq h3xxx
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Dmitry Artamonow <mad_soft@inbox.ru>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 11:33 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:

> From: Dmitry Artamonow <mad_soft@inbox.ru>
>
> This adds a driver for reading the battery status of the
> battery connected to the Atmel microcontroller on the
> iPAQ h3xxx series.
>
> Based on a driver from handhelds.org 2.6.21 kernel, written
> by Alessandro GARDICH.
>
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Ping on this.

Yours,
Linus Walleij
