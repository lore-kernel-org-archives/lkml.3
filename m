Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab3C0Im5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:42:57 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36310 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3C0Imz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:42:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAK9yfHw8df1ktZNYx=998_KmbvUt-be8vGo=kSC52DsEF5utAw@mail.gmail.com>
References: <1363253249-3128-1-git-send-email-gheorghiuandru@gmail.com>
	<CAK9yfHw8df1ktZNYx=998_KmbvUt-be8vGo=kSC52DsEF5utAw@mail.gmail.com>
Date: Wed, 27 Mar 2013 09:42:55 +0100
Message-ID: <CACRpkdY1xBTHQsJ2Grru0gw0URXUiBy1XmnFDXPPRbR5xNJtTg@mail.gmail.com>
Subject: Re: [PATCH] drivers: gpio: Use devm_ioremap_resource function
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Alexandru Gheorghiu <gheorghiuandru@gmail.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 10:34 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> On 14 March 2013 14:57, Alexandru Gheorghiu <gheorghiuandru@gmail.com> wrote:
>> Use the newly introduced devm_ioremap_resource() instead of
>> devm_request_and_ioremap() which provides more consistent error
>> handling.
>>
>> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
>
> Similar patch has already been submitted:
> https://lkml.org/lkml/2013/3/4/124

I've applied the earlier patch.

Yours,
Linus Walleij
