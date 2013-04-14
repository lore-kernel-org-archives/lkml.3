Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3DNSlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 14:41:09 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:44515 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab3DNSlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 14:41:08 -0400
X-Auth-Info: hnQrN1y5qx/lQCBqXMn9HErtk+Q6PJjLp7X/0zyavDc=
From: Marek Vasut <marex@denx.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] UCB1400: Pass ucb1400-gpio data through ac97 bus
Date: Sun, 14 Apr 2013 20:40:47 +0200
User-Agent: KMail/1.13.7 (Linux/3.8-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>, Jean Delvare <jdelvare@suse.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
References: <CACRpkdZ+ku_-SBTXwwwRDh7F2TXzpgpAF3k+Ksn98BNYXximXw@mail.gmail.com> <1365964548-4193-1-git-send-email-marex@denx.de>
In-Reply-To: <1365964548-4193-1-git-send-email-marex@denx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304142040.48132.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Marek Vasut,

> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Jean Delvare <jdelvare@suse.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-kernel <linux-kernel@vger.kernel.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Marek Vasut <marex@denx.de>
> ---
>  drivers/gpio/gpio-ucb1400.c |   19 ++++++-------------
>  drivers/mfd/ucb1400_core.c  |    5 +++++
>  include/linux/ucb1400.h     |   18 ++++++------------
>  3 files changed, 17 insertions(+), 25 deletions(-)
> 
> v2: Rebase patch from:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2010-October/028656.h
> tml
> 
> NOTE: I didn't even compile-test this, but the fix was plenty
> straightforward.

But damn, this code is ugly. I'm retrospectively-ashamed.

Best regards,
Marek Vasut
