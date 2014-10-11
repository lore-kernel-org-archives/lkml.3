Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaJKSwH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:52:07 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37669 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaJKSwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:52:05 -0400
Message-ID: <54397C51.20804@gmail.com>
Date: Sat, 11 Oct 2014 20:52:01 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>
CC: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v2 0/5] pinctrl: samsung: Data structure clean-up
References: <1412275931-10807-1-git-send-email-tomasz.figa@gmail.com> <CACRpkdY1GjDEfRH=48e24m+UcKzdPhROJBKDertS+q+e0td03g@mail.gmail.com>
In-Reply-To: <CACRpkdY1GjDEfRH=48e24m+UcKzdPhROJBKDertS+q+e0td03g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.10.2014 12:23, Linus Walleij wrote:
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

OK, thanks.

> 
> Now I need you to help me check the patch set from Abhilash so I know
> what to do about that, whenever you have some time...

I've already acked previous version of that series, only with some minor
nitpicks pointed, but let me take a look at last version.

Best regards,
Tomasz
