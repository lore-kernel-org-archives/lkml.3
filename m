Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3AVMm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 07:42:58 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:60849 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3AVMm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 07:42:57 -0500
MIME-Version: 1.0
In-Reply-To: <20130121234158.GA9322@kroah.com>
References: <1358795855-21064-1-git-send-email-linus.walleij@stericsson.com>
	<20130121234158.GA9322@kroah.com>
Date: Tue, 22 Jan 2013 13:42:57 +0100
Message-ID: <CACRpkdY2LF4Kg0LsZGThKpQfv=TPfK9NfX0O71OHeT+Jqh++hg@mail.gmail.com>
Subject: Re: [PATCH v4] drivers/pinctrl: grab default handles from device core
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 12:41 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Jan 21, 2013 at 08:17:35PM +0100, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> This makes the device core auto-grab the pinctrl handle and set
>> the "default" (PINCTRL_STATE_DEFAULT) state for every device
>> that is present in the device model right before probe. This will
>> account for the lion's share of embedded silicon devcies.
(...)
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Feel free to take this through your tree.

Thanks Greg!

Stephen W, are you OK with me pushing this version of the patch
now?

I have your fix and hopefully the other required fixes in the patch
so as not to break Tegra, but prefer to have it solidly tested
if possible.

Yours,
Linus Walleij
