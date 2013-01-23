Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab3AWIgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 03:36:39 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:40390 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab3AWIgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 03:36:38 -0500
MIME-Version: 1.0
In-Reply-To: <20130122102558.GA10716@avionic-0098.adnet.avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
	<1358762966-20791-9-git-send-email-thierry.reding@avionic-design.de>
	<CACRpkdb8VEUENBD8nSexYYPekDp082mK-A07hw7e8VmVSxZS3A@mail.gmail.com>
	<20130122102558.GA10716@avionic-0098.adnet.avionic-design.de>
Date: Wed, 23 Jan 2013 09:36:36 +0100
Message-ID: <CACRpkdbqFx7gKeYkzEWkw++sim7aOZrLNdj36SLX9skQQJ2LCg@mail.gmail.com>
Subject: Re: [PATCH 08/33] gpio: Convert to devm_ioremap_resource()
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 11:25 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Tue, Jan 22, 2013 at 11:15:11AM +0100, Linus Walleij wrote:
>> On Mon, Jan 21, 2013 at 11:09 AM, Thierry Reding
>> <thierry.reding@avionic-design.de> wrote:
>>
>> > Convert all uses of devm_request_and_ioremap() to the newly introduced
>> > devm_ioremap_resource() which provides more consistent error handling.
>> >
>> > devm_ioremap_resource() provides its own error messages so all explicit
>> > error messages can be removed from the failure code paths.
>> >
>> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>> > Cc: Grant Likely <grant.likely@secretlab.ca>
>> > Cc: Linus Walleij <linus.walleij@linaro.org>
>>
>> Is the interface already in-kernel so I should apply this or is it
>> added as part of this series so you're searching an ACK?
>
> It is part of this series, so your Acked-by would be great.

Fair enough,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
