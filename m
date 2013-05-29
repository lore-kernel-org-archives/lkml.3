Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966183Ab3E2TDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:03:06 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:40380 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965803Ab3E2TDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:03:02 -0400
MIME-Version: 1.0
In-Reply-To: <51A627A0.3000603@imgtec.com>
References: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
	<1369412476-14245-8-git-send-email-james.hogan@imgtec.com>
	<CACRpkdb-JNbWxUiiJf=2Y8C0txcKBVoFjBCwkaMVq4my1nzHzQ@mail.gmail.com>
	<51A627A0.3000603@imgtec.com>
Date: Wed, 29 May 2013 22:03:00 +0300
Message-ID: <CAHp75VcAnS90yT9KanfR4=zViG2S=_RUrviokEA7jxC=eu59rQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/9] gpio-tz1090: add TZ1090 gpio driver
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 7:06 PM, James Hogan <james.hogan@imgtec.com> wrote:
> (for the record, in drivers/gpio/*.c:
>       1 core_initcall
>       1 device_initcall

I think this one should go to the subsys_initicall (I didn't check,
but I recall that is gpio-langwell driver).

>       1 late_initcall
>       2 pure_initcall
>       3 arch_initcall
>      14 postcore_initcall
>      29 subsys_initcall)


--
With Best Regards,
Andy Shevchenko
