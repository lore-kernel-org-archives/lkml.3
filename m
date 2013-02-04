Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3BDUr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:47:26 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:43634 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab3BDUrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:47:25 -0500
MIME-Version: 1.0
In-Reply-To: <1359967324-13074-1-git-send-email-acourbot@nvidia.com>
References: <1359967324-13074-1-git-send-email-acourbot@nvidia.com>
Date: Mon, 4 Feb 2013 21:47:25 +0100
Message-ID: <CACRpkdbGJg_9wPrCZMbOzFT+iiOhjGg0cSQohBH-mx+2O0PXzQ@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: add missing braces in gpio_direction_show
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 4, 2013 at 9:42 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Add missing braces in an if..else condition.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Applied, thanks!

Yours,
Linus Walleij
