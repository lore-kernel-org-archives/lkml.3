Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab3GVR3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:29:11 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:54940 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502Ab3GVR3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:29:09 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <CACxGe6tqisx19LP=5gPyF1iuBKedTLp0yK+WgmqG5Cf+a95Taw@mail.gmail.com>
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
	<1374290388-19308-3-git-send-email-grant.likely@linaro.org>
	<CAOesGMhaAy93J=Q1STZUHHA-SbH+WXCVuUn0ef14_18du2dk6w@mail.gmail.com>
	<1374366577.1940.10.camel@joe-AO722>
	<CACxGe6tqisx19LP=5gPyF1iuBKedTLp0yK+WgmqG5Cf+a95Taw@mail.gmail.com>
Date: Mon, 22 Jul 2013 10:29:08 -0700
Message-ID: <CAOesGMjdH6x9U0+6f6TC8Q=sCbO38aNedqTpHBe5cpLG79r3eA@mail.gmail.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@linaro.org>
Cc: Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 2:46 AM, Grant Likely <grant.likely@linaro.org> wrote:
> On Sun, Jul 21, 2013 at 1:29 AM, Joe Perches <joe@perches.com> wrote:
>> On Sat, 2013-07-20 at 17:17 -0700, Olof Johansson wrote:
>>> On Fri, Jul 19, 2013 at 8:19 PM, Grant Likely <grant.likely@linaro.org> wrote:
>>> > Device tree bindings require a lot more attention than they used to.
>>> > We've got a group of volunteers willing to take over maintaining
>>> > bindings. This patch adds them to the MAINTAINERS file.
>> []
>>> > diff --git a/MAINTAINERS b/MAINTAINERS
>> []
>>> > +OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS
>> []
>>> > +F:     arch/*/
>> []
>>> This seems a bit broad.
>>
>> Yep, that's every file anywhere under arch.
>
> yeah, that was a c/p mistake. I'll drop that line before committing.

Ok, with that:

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
