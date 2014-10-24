Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979AbaJXMCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:02:53 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:56452 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbaJXMCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:02:51 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdY1GjDEfRH=48e24m+UcKzdPhROJBKDertS+q+e0td03g@mail.gmail.com>
References: <1412275931-10807-1-git-send-email-tomasz.figa@gmail.com>
	<CACRpkdY1GjDEfRH=48e24m+UcKzdPhROJBKDertS+q+e0td03g@mail.gmail.com>
Date: Fri, 24 Oct 2014 14:02:50 +0200
Message-ID: <CACRpkdbFB+o5VAtHUf97GAONmSFc_7wMuzPN8p_JDdiGW8vfLA@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] pinctrl: samsung: Data structure clean-up
From: Linus Walleij <linus.walleij@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 12:23 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Oct 2, 2014 at 8:52 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>
>> This series intends to clean up data structures used by pinctrl-samsung driver.
>> More specifically, it separates initial compile time constants from data used
>> at runtime, allowing unused variant data to be dropped and selected structures
>> constified to improve safety.
>
> Thanks!
>
> The patches missed the v3.18 merge window, but I have queued them up as
> the first thing to go into v3.19.

I wrote somewhere else that this exploded somehow.

I've merged Abhilash's patches so now this work needs to be rebased
on top of his stuf...


Yours,
Linus Walleij
