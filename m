Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab3CVHz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 03:55:58 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:35391 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3CVHz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 03:55:57 -0400
MIME-Version: 1.0
In-Reply-To: <512CC357.9040600@nvidia.com>
References: <1361884868-27783-1-git-send-email-ian@slimlogic.co.uk>
	<512CBF75.9000103@nvidia.com>
	<512CC31D.6070602@slimlogic.co.uk>
	<512CC357.9040600@nvidia.com>
Date: Fri, 22 Mar 2013 08:55:56 +0100
Message-ID: <CACRpkdZyBB+Bqevgi7dGw+nWu245RgKNv7Cpim4YRuhYbcP1xw@mail.gmail.com>
Subject: Re: [PATCH] gpio: palmas: add in GPIO support for palmas charger
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Ian Lartey <ian@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 3:14 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> On Tuesday 26 February 2013 07:43 PM, Ian Lartey wrote:
> On 26/02/13 13:58, Laxman Dewangan wrote:
>
> On Tuesday 26 February 2013 06:51 PM, Ian Lartey wrote:
>
> this patch depenfs on [PATCH] mfd: palmas: is_palmas_charger needed by
> multiple drivers
>
> Palmas charger has 16 GPIOs
> add palmas_gpio_[read|write|update] api to take account
> second bank of GPIOs
>
> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>

Is something happening in this series?

I'm ignoring it for now since the last activity in the thread was
some concerns from Laxman.

Yours,
Linus Walleij
