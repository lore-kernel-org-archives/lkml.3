Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab3AQQbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:31:09 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:32984 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab3AQQbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:31:06 -0500
Message-ID: <50F82745.6050507@wwwdotorg.org>
Date: Thu, 17 Jan 2013 09:31:01 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Kevin Hilman <khilman@ti.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Mitch Bradley <wmb@firmworks.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-next@vger.kernel.org
Subject: Re: [PATCH v2] drivers/pinctrl: grab default handles from device
 core
References: <1355343907-11535-1-git-send-email-linus.walleij@stericsson.com> <50EF27B4.60608@wwwdotorg.org> <CACRpkdZ0b=ZohgaBH3qPH_O5TiWmXJXs6872D+YPVA9g4BssYg@mail.gmail.com> <9702060.jEbHySsCv0@avalon> <CACRpkdbFH6RCEEnXO=A9FVa0B5rtE9RkjXz9Hhy+w7NvwcBCgg@mail.gmail.com> <50F6E811.2040606@wwwdotorg.org> <20130117060214.GC1197@verge.net.au>
In-Reply-To: <20130117060214.GC1197@verge.net.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 11:02 PM, Simon Horman wrote:
> On Wed, Jan 16, 2013 at 10:49:05AM -0700, Stephen Warren wrote:
>> On 01/11/2013 01:45 PM, Linus Walleij wrote:
>>> On Fri, Jan 11, 2013 at 9:36 PM, Laurent Pinchart
>>> <laurent.pinchart@ideasonboard.com> wrote:
>>>
>>>> I've sent several patch series for the SH PFC (Pin Function Controller) to the
>>>> linux-sh mailing list. One of the series included pinctrl core patches for
>>>> easier testing, but I made it clear that they should *not* be pushed to
>>>> mainline through the SH tree.
>>>
>>> No big deal, what fun is linux-next if we don't break it ;-)
>>
>> Hmm. It's causing a lot of engineers here a lot of trouble, since they
>> all see linux-next won't boot, and haven't been paying enough attention
>> to know which commit to revert:-(. Lots of lost productivity:-(
>>
>> Simon, the offending commit:
>>
>> 6d3ef6b drivers/pinctrl: grab default handles from device core
>>
>> is still in next-20130116. Can you please remove it?
> 
> I removed the commit yesterday.
> Please let me know if it seems to be lingering.

Thanks. I believe it's gone from next-20130117, judging by a quick
search through "git log" at least.
