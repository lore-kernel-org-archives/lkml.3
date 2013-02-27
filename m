Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389Ab3B0BWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:22:46 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:61493 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759891Ab3B0BWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 20:22:45 -0500
MIME-Version: 1.0
In-Reply-To: <20130226175311.D17173E2EF8@localhost>
References: <1360907177-6468-1-git-send-email-acourbot@nvidia.com>
 <CAAVeFuLP0KLVL-0SS+nGWSoK1RMPCmKgZV-OjMJo-h7E1UVuXw@mail.gmail.com> <20130226175311.D17173E2EF8@localhost>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 27 Feb 2013 10:22:24 +0900
Message-ID: <CAAVeFuLazaZEbbUVtR_Zyub3hgTesW6JcD9Kxgk7dUXuESpLOw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] gpiolib: some fixup patches
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>, Ryan Mallon <rmallon@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "acourbot@nvidia.com" <acourbot@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 2:53 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, 22 Feb 2013 11:19:44 +0900, Alexandre Courbot <gnurou@gmail.com> wrote:
>> Grant, will you be able to include these for 3.9? They fix code that
>> you merged recently, so I'd be glad if they could be squashed into the
>> patch mentioned in the description.
>
> They won't get squashed in because the tree is already composed and in
> linux-next. I don't rebase unless I really need to. I've applied them
> and I'll probably push to Linus since they are effectively bug fixes of
> a sort and the merge window hasn't closed yet.

That's fine too - as long as the patches with side-effects are merged.
That will allow me to continue going forward with GPIO, thanks!

Alex.
