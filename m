Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaDPGMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 02:12:51 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:59813 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbaDPGMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 02:12:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140415142024.GD3207@lukather>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
 <1397544101-18135-2-git-send-email-wens@csie.org> <20140415142024.GD3207@lukather>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 16 Apr 2014 15:12:26 +0900
Message-ID: <CAAVeFuLDhTVGDnmYtnxEY8hhn6HE6tU9OB24WDPtmxEHjiRiuQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] gpiolib: gpiolib-of: Implement device tree gpio-names
 based lookup
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, Linus Walleij <linus.walleij@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 11:20 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi Chen-Yu,
>
> On Tue, Apr 15, 2014 at 02:41:35PM +0800, Chen-Yu Tsai wrote:
>> This patch provides of_get_gpiod_flags_by_name(), which looks up GPIO
>> phandles by name only, through gpios/gpio-names, and not by index.
>
> IIRC, gpios only uses the *-gpios properties, and not gpios/gpio-names
> pattern seen on various other things.
>
> Is it some new property you introduce? If so, please add it to the
> documentation.
>
> Now, I'm not sure that having two distinct representations of GPIOs in
> the DT is a good thing. Yes, it's looking odd compared to other
> similar bindings, but it's what we have to deal with.

Mmmm I *think* I somehow remember a discussion about this topic
recently, but I cannot find it. Maybe Chen-yu could point us to the
conclusion of this discussion and the rationale for (re)implementing
named GPIOs this way?
