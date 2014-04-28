Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979AbaD1QUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 12:20:00 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:47534 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277AbaD1QTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 12:19:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFuL7B7kVw7ME=Vo_snhG27aBphKO8Uzvzen1gyD=R2ETNA@mail.gmail.com>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
 <1397544101-18135-2-git-send-email-wens@csie.org> <CACRpkdZDjC1KxM2yJqsgpg2MxBamX1EObsuahB-2c+ShuBXm8A@mail.gmail.com>
 <CAAVeFuL7B7kVw7ME=Vo_snhG27aBphKO8Uzvzen1gyD=R2ETNA@mail.gmail.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 29 Apr 2014 00:19:34 +0800
X-Google-Sender-Auth: BHSyAZaERTFP2sNCaO2gXsmEOgs
Message-ID: <CAGb2v64rs4UYMbQ--i=pcuuORVneozDpucCeHQKE4Qn7+qSCdA@mail.gmail.com>
Subject: Re: [linux-sunxi] Re: [PATCH 1/7] gpiolib: gpiolib-of: Implement
 device tree gpio-names based lookup
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 9:49 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Wed, Apr 23, 2014 at 12:02 AM, Linus Walleij
> <linus.walleij@linaro.org> wrote:
>> On Tue, Apr 15, 2014 at 8:41 AM, Chen-Yu Tsai <wens@csie.org> wrote:
>>
>>> This patch provides of_get_gpiod_flags_by_name(), which looks up GPIO
>>> phandles by name only, through gpios/gpio-names, and not by index.
>>>
>>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>>
>> Like Alexandre I have no strong opinion on this alternative scheme.
>
> Yeah this new lookup scheme probably does no harm, but I think it
> should be a little bit more motivated as it is, after all, introducing
> more potential confusion for DT users.
>
> It does not look like this new lookup scheme is necessary to Chen-Yu's
> patchset and that he could as well have used the current one. Right
> now there is only one way to define GPIOs - if we introduce a second
> one, then which one should new DT users choose? Which one looks
> better? I can already endless fights taking place over this.

I will pull out the two patches.

> Does this new lookup help with some of the existing problems we have
> like ACPI/DT lookup compatibility?

I hope they will be compatible with ACPI named gpios, whenever support
for ACPI named properties extension lands. But that really depends on
the ACPI implementation. For now I think it's best that I just hold on
to these. We can revisit the discussion later if needed.

> I just need to be given one practical reason to give my ack.


Thanks
ChenYu
