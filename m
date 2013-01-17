Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562Ab3AQKeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:34:44 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:56145 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759489Ab3AQKem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:34:42 -0500
MIME-Version: 1.0
In-Reply-To: <1357210020-19876-4-git-send-email-ldewangan@nvidia.com>
References: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
	<1357210020-19876-4-git-send-email-ldewangan@nvidia.com>
Date: Thu, 17 Jan 2013 11:34:42 +0100
Message-ID: <CACRpkdazCa_GMfrCnoYukiQKbKD41RiTG-MyO-5p+B-6-+Y=hA@mail.gmail.com>
Subject: Re: [PATCH 3/4] gpio: palmas: Add support for Palams GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca,
        akpm@linux-foundation.org, a.zummo@towertech.it,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 11:46 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Add gpio driver for TI Palmas series PMIC. This has 8 gpio which can
> work as input/output.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

OK you & Mark have convinced me that this driver is OK as it stands.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Do you want me to apply it to my GPIO tree or does it have
dependencies so you'll take it through MFD or something?

Yours,
Linus Walleij
