Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab3IKUw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:52:57 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:40911 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab3IKUw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:52:56 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <CA+bK7J4s1y5-CfwmNB3gN5Ed800AnuH6vHe8+jRmq+pyPu9o0A@mail.gmail.com>
References: <CACxGe6v8hO4sRX_KGcH=YBAMrF8mQHqWdxXEvVwoC2pVS5Yv9Q@mail.gmail.com>
	<CA+bK7J5cAWFPLTBR2afNLm2JaKFH4_dJO_NpVL5gom0iX+L2dQ@mail.gmail.com>
	<CA+55aFzBbKXJnaG_6X8Fff_APGJ3EkbG0thsbithDXtiEJjdHA@mail.gmail.com>
	<CA+8MBbLVC2==zpNV1zV3OoiSQoKfptAGqF1EQNtrhFUCn=0h7A@mail.gmail.com>
	<CA+bK7J4s1y5-CfwmNB3gN5Ed800AnuH6vHe8+jRmq+pyPu9o0A@mail.gmail.com>
Date: Wed, 11 Sep 2013 13:52:55 -0700
Message-ID: <CAOesGMhUAqKWsJEnK1-5TwRpE62WqVug9kYEziaJ3dtkEiGs4g@mail.gmail.com>
Subject: Re: [GIT PULL] Device tree updates for v3.12
From: Olof Johansson <olof@lixom.net>
To: Tim Bird <tbird20d@gmail.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 1:21 PM, Tim Bird <tbird20d@gmail.com> wrote:
> Thanks.  This gives me an order-of-magnitude measurement for this sort of thing.
> I'll measure it directly myself on our hardware as soon as I can.
>
> I've heard an ugly rumor that the device tree from our silicon vendor
> may grow to be
> as big as 130K in the near future. I'm still following up to see if
> there's any truth
> to this (so don't quote me on it), but if it does get that big it
> might be an issue.  As
> stated previously, the vast majority of our device tree files consists
> of values that
> are not device-specific.

The biggest ones in mainline today compile to a ~30K binary. Not sure
a vendor expects to add in there to gain another 100KB.


-Olof
