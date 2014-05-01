Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaEAEGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 00:06:00 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:41619 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaEAEF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 00:05:58 -0400
MIME-Version: 1.0
In-Reply-To: <1398846369.19894.21.camel@paszta.hi.pengutronix.de>
References: <1398789430-23897-1-git-send-email-p.zabel@pengutronix.de>
	<CAL_JsqJLhino_s+BhiApRYBtbUvyrn4KF0Zax7YKP_HYLye5gw@mail.gmail.com>
	<1398846369.19894.21.camel@paszta.hi.pengutronix.de>
Date: Wed, 30 Apr 2014 21:05:57 -0700
Message-ID: <CAJ+vNU05jv48zuH3C=FGeCjk-e9D5OU1xbdnY=vkbgqFWHX-9A@mail.gmail.com>
Subject: Re: [PATCH 1/3] of: Add vendor prefix for Linear Technology Corporation
From: Tim Harvey <tharvey@gateworks.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Rob Herring <robherring2@gmail.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 1:26 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Am Dienstag, den 29.04.2014, 15:44 -0500 schrieb Rob Herring:
>> On Tue, Apr 29, 2014 at 11:37 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
>> > Add Linear Technology Corporation to the list of device tree vendor prefixes.
>> >
>> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>> > ---
>> >  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>> >  1 file changed, 1 insertion(+)
>> >
>> > diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
>> > index 0f01c9b..3d27991 100644
>> > --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
>> > +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
>> > @@ -65,6 +65,7 @@ lantiq        Lantiq Semiconductor
>> >  lg     LG Corporation
>> >  linux  Linux-specific binding
>> >  lsi    LSI Corp. (LSI Logic)
>> > +ltc    Linear Technology Corporation
>>
>>
>> Following the use of stock symbols, this should be lltc. Is this already in use?
>
> [Added Tim Harvey to Cc]
>
> That depends on the definition of 'in use'.
>
> grep found arch/arm/boot/dts/imx6qdl-gw5[123]xx.dtsi containing
> a "ltc,ltc3676" compatible, but I haven't seen the corresponding
> driver yet. I suspect at this point we still can switch to use lltc
> instead of ltc as vendor prefix without hurting anybody.
>
> regards
> Philipp
>

Hi Philipp,

Right, it can be changed. That node is a placeholder to describe the
hardware until myself or someone else has time to write the driver for
it.

Regards,

Tim
