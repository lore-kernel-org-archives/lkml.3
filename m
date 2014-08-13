Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaHMIDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:03:13 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:59935 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaHMIDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:03:07 -0400
Date: Wed, 13 Aug 2014 09:03:01 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RESEND: PATCH 1/2] mfd: tc3589x: Add device tree bindings
Message-ID: <20140813080301.GA18712@lee--X1>
References: <1397028480-15413-1-git-send-email-linus.walleij@linaro.org>
 <20140617202340.GW29841@lee--X1>
 <CACRpkdY2xjp9=muE5WFoN3smzgC+cqR0ijgD306nXi7owEGyyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdY2xjp9=muE5WFoN3smzgC+cqR0ijgD306nXi7owEGyyw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2014, Linus Walleij wrote:

> On Tue, Jun 17, 2014 at 10:23 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Wed, 09 Apr 2014, Linus Walleij wrote:
> >
> >> This defines the device tree bindings for the Toshiba TC3589x
> >> series of multi-purpose expanders. Only the stuff I can test
> >> is defined: GPIO and keypad. Others may implement more
> >> subdevices further down the road.
> >>
> >> This is to complement
> >> commit a435ae1d51e2f18414f2a87219fdbe068231e692
> >> "mfd: Enable the tc3589x for Device Tree" which left off
> >> the definition of the device tree bindings.
> >>
> >> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> >> ---
> >> ChangeLog v2->v3:
> >> - Fix the keys/rows bindings to be u32 rather than
> >>   /bits/ 8, inconsistency noted by Mark Rutland.
> >> ChangeLog v1->v2:
> >> - Include a verbose example in the DT bindings.
> >> - Explain why this is a stand-alone bindings patch.
> >> ---
> >>  Documentation/devicetree/bindings/mfd/tc3589x.txt | 107 ++++++++++++++++++++++
> >>  1 file changed, 107 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/mfd/tc3589x.txt
> >
> > Looks about right, been on the list for ages and doesn't add any new
> > properties.  Applied, thanks.
> 
> This wasn't in the v3.17 pull request AFAICT :-(
> 
> Did it get dropped to the floor accidentally?

It doesn't look like this was ever actually applied to the MFD tree
i.e I can't find it in my git history (reflog), sorry Linus.  I have a
-fixes branch and will attempt to send this patch as a part of that.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
