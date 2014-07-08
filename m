Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaGHJjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:39:04 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:58186 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbaGHJjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:39:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140708080535.GJ13423@lukather>
References: <1403098673-3058-1-git-send-email-houcheng@gmail.com>
	<CACRpkdYfu8HmVCkn9JFh+YP5OPdr8o9nTfoCnkJ7SSpGoenQUg@mail.gmail.com>
	<20140708080535.GJ13423@lukather>
Date: Tue, 8 Jul 2014 11:38:59 +0200
Message-ID: <CACRpkdbFPAsu1gE-AVyD=-RxyE7mUJPSbFga7HLh0mxjE-mQuQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3] reset: Add a defer reset object to send board
 specific reset
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Houcheng Lin <houcheng@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, sre@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Vikas Sajjan <vikas.sajjan@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 10:05 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Tue, Jul 08, 2014 at 09:52:03AM +0200, Linus Walleij wrote:
>> On Wed, Jun 18, 2014 at 3:37 PM, Houcheng Lin <houcheng@gmail.com> wrote:
>>
>> > The Problem
>> > -----------
>> > The reset signal on a hardware board is send either:
>> >     - during machine initialization
>> >     - during bus master's initialization
>>
>> I just thought about this a bit, since there isn't already a generic GPIO
>> reset driver, just call this drivers/reset/reset-gpio.c and make the
>> ability to deferral just a configuration detail of the GPIO reset driver.
>
> Philipp has been working on one for quite some time. See
> http://www.spinics.net/lists/arm-kernel/msg321927.html
>
> However, it seems to progress slowly, and we don't seem to be able to
> reach a consensus here.
>
> If you ask me, having to set a few extra properties like this just
> advocates for a regular reset driver and DT node for the reset GPIO,
> but I'm pretty sure Philipp will feel otherwise :)

Hm haha yeah let's fight it out :-)

This is not my subsystem so I'm getting some popcorn.

Yours,
Linus Walleij
