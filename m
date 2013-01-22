Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3AVLjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:39:13 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:58908 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3AVLjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:39:12 -0500
Message-ID: <50FE7A57.4010205@free-electrons.com>
Date: Tue, 22 Jan 2013 12:39:03 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 08/33] gpio: Convert to devm_ioremap_resource()
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de> <1358762966-20791-9-git-send-email-thierry.reding@avionic-design.de> <CACRpkdb8VEUENBD8nSexYYPekDp082mK-A07hw7e8VmVSxZS3A@mail.gmail.com>
In-Reply-To: <CACRpkdb8VEUENBD8nSexYYPekDp082mK-A07hw7e8VmVSxZS3A@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 11:15 AM, Linus Walleij wrote:
> On Mon, Jan 21, 2013 at 11:09 AM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> 
>> Convert all uses of devm_request_and_ioremap() to the newly introduced
>> devm_ioremap_resource() which provides more consistent error handling.
>>
>> devm_ioremap_resource() provides its own error messages so all explicit
>> error messages can be removed from the failure code paths.
>>
>> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
> 
> Is the interface already in-kernel so I should apply this or is it
> added as part of this series so you're searching an ACK?

I don't know if I was really the one you were looking for (either
you wanted to send it to an other Greg(ory) or to Thomas Petazzoni who
wrote the gpio-mvebu.c driver). However, that's fortunate because
Thomas is currently in on vacations, so I apply this patch and the
first of the series, I built, compiled and tested it on an Aramda XP DB
board. Everything is OK for me.

So for sure you can have my
Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

and as the code looks good, so for what it's worth, you can even get my
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
