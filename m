Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab3JWIJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:09:58 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:56219 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab3JWIJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:09:56 -0400
MIME-Version: 1.0
In-Reply-To: <1382307299-22587-2-git-send-email-acourbot@nvidia.com>
References: <1382307299-22587-1-git-send-email-acourbot@nvidia.com>
	<1382307299-22587-2-git-send-email-acourbot@nvidia.com>
Date: Wed, 23 Oct 2013 10:09:55 +0200
Message-ID: <CACRpkdbsvoYrXmApmCrEfjS8zN989PQqKJMppJUz8VbFdb_LnA@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpiolib: devres: fix devm_gpiod_get_index()
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 12:14 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Fix the return value if devm_gpiod_get_index(). It was returning 0 while
> it should return the obtained GPIO descriptor.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Patch applied.

Yours,
Linus Walleij
