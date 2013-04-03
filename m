Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761699Ab3DCNkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:40:08 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:61567 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab3DCNkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:40:05 -0400
MIME-Version: 1.0
In-Reply-To: <1364970291-17721-1-git-send-email-linux@prisktech.co.nz>
References: <1364970291-17721-1-git-send-email-linux@prisktech.co.nz>
Date: Wed, 3 Apr 2013 15:40:05 +0200
Message-ID: <CACRpkdZAtgpfA5rZ_C=eKDDOE9aDm=3k1QDava=EGL2BaoV+0g@mail.gmail.com>
Subject: Re: [PATCHv5 0/7] arm: vt8500: Add support for pinctrl/gpio module
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 8:24 AM, Tony Prisk <linux@prisktech.co.nz> wrote:

> v5 changes:
> Changed as requested by Rob Herring:
> Added of_find_property_value_of_size() to drivers/of/base.c to remove some
> code that was being duplicated.
>
> Changed as requested by Stephen Warren:
> Redid the kfree(maps) code as devm_kzalloc would cause issues. We now kzalloc
> maps all at once, and configs as required. A call to wmt_pctl_dt_free_map() is
> used to kfree the allocated blocks if we fail early.

This v5 series:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

I guess it will go in through the VT8500 tree eventually?

Maybe you could put Stephen's BCMring patch on top when sending
it in (also Acked-by) so we can avoid having that dangling.

Yours,
Linus Walleij
