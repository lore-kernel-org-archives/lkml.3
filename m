Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab3H1N4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:56:55 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:36230 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab3H1N4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:56:52 -0400
MIME-Version: 1.0
In-Reply-To: <3439226.L4MiyJHvQr@amdc1227>
References: <1377608890-8528-1-git-send-email-m.krawczuk@partner.samsung.com>
	<CACRpkdYiB5OG-YPRozwEurPHECDzZjQUs2s_E8gCdeqDPyr+WA@mail.gmail.com>
	<3439226.L4MiyJHvQr@amdc1227>
Date: Wed, 28 Aug 2013 15:56:52 +0200
Message-ID: <CACRpkdaZAqTZ7rBrBLrs93VYjXFbUnrgvy4yt=VPrc07Ye14ow@mail.gmail.com>
Subject: Re: [Patch v2] pinctrl: Add s5pv210 support to pinctrl-exynos
From: Linus Walleij <linus.walleij@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Leelakrishna A <l.krishna@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 2:58 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> On Wednesday 28 of August 2013 14:51:44 Linus Walleij wrote:
>> On Tue, Aug 27, 2013 at 3:08 PM, Mateusz Krawczuk
>>
>> <m.krawczuk@partner.samsung.com> wrote:
>> > This patch implements pinctrl support and adds device tree bindings
>> > for s5pv210.
>> >
>> > Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
>>
>> Oh this one does add bindings, sorry for previous comment.
>>
>> I want an ACK from Kukjin or Sylwester for this since it's
>> something new for S5P.
>
> Well, it does not touch anything outside drivers/pinctrl/, so my and your
> ACKs should be enough, but since this patch is just one day old, let's give
> it a bit more time for people to review it, if you don't have to hurry with
> it yet.

Patch applied with Sylwester's ACK!

Yours,
Linus Walleij
