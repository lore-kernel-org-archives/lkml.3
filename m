Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab3C0I4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:56:33 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:49908 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab3C0I4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:56:31 -0400
MIME-Version: 1.0
In-Reply-To: <006a01ce215d$f9b44860$ed1cd920$%han@samsung.com>
References: <006901ce215d$e42c0b90$ac8422b0$%han@samsung.com>
	<006a01ce215d$f9b44860$ed1cd920$%han@samsung.com>
Date: Wed, 27 Mar 2013 09:56:31 +0100
Message-ID: <CACRpkdbgqUe5Fsbk1Xj851epxe8xBrSCoyJxMAtJwjyXjbzJsg@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: mc33880: use spi_get_drvdata() and spi_set_drvdata()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 10:17 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Use the wrapper functions for getting and setting the driver data
> using spi_device instead of using dev_{get|set}_drvdata with
> &spi->dev, so we can directly pass a struct spi_device.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.

Thanks!
Linus Walleij
