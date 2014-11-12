Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaKLSUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:20:36 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:33770 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaKLSUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:20:35 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZUZJmSrHVH4BbNbANgN-BphYL_wCF=6QdXndXdXYXiZg@mail.gmail.com>
References: <1415100672-31425-1-git-send-email-linus.walleij@linaro.org>
	<CACRpkdZUZJmSrHVH4BbNbANgN-BphYL_wCF=6QdXndXdXYXiZg@mail.gmail.com>
Date: Wed, 12 Nov 2014 22:20:34 +0400
Message-ID: <CALT56yM15FbKm6RKqUe59cWtMSfZgOR7koYcgM_J3F_TyHp2WA@mail.gmail.com>
Subject: Re: [PATCH] power: reset: augment versatile driver for integrator
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Reichel <sre@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-12 17:54 GMT+03:00 Linus Walleij <linus.walleij@linaro.org>:
> On Tue, Nov 4, 2014 at 12:31 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>
>> Augment the Versatile reset driver to also handle the core
>> module reset sequence used on the Integrator/AP and
>> Integrator/CP.
>>
>> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: Sebastian Reichel <sre@kernel.org>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>> Sebastian: please merge this into your power tree if you're
>> OK with it, the corresponding platform changes are orthogonal
>> so these can go separately through the ARM SoC tree.
>
> Power folks: ping on this patch.

I will apply tomorrow, if Sebastian does not respond earlier.

-- 
With best wishes
Dmitry
