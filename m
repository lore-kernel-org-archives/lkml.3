Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab3GVAtE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:49:04 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44861 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab3GVAtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:49:02 -0400
MIME-Version: 1.0
In-Reply-To: <1374453831.2061.10.camel@joe-AO722>
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
 <1374290388-19308-3-git-send-email-grant.likely@linaro.org>
 <CAOesGMhaAy93J=Q1STZUHHA-SbH+WXCVuUn0ef14_18du2dk6w@mail.gmail.com>
 <1374366577.1940.10.camel@joe-AO722> <CACxGe6tqisx19LP=5gPyF1iuBKedTLp0yK+WgmqG5Cf+a95Taw@mail.gmail.com>
 <CACxGe6tJedLnM6FmvuQWTpGNFsefTn14cbnBMoWnr1gfA0seoQ@mail.gmail.com> <1374453831.2061.10.camel@joe-AO722>
From: Grant Likely <grant.likely@linaro.org>
Date: Mon, 22 Jul 2013 01:48:41 +0100
X-Google-Sender-Auth: EH8vAi3M1BfPS8pJEhOsp6jhH_Q
Message-ID: <CACxGe6szWY8=u4ewi6HZWFk7+Zho+9F6c4-YXKUaB_NXhd3GZg@mail.gmail.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
To: Joe Perches <joe@perches.com>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 1:43 AM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2013-07-22 at 01:36 +0100, Grant Likely wrote:
>> On Sun, Jul 21, 2013 at 10:46 AM, Grant Likely <grant.likely@linaro.org> wrote:
>> > On Sun, Jul 21, 2013 at 1:29 AM, Joe Perches <joe@perches.com> wrote:
>> >> On Sat, 2013-07-20 at 17:17 -0700, Olof Johansson wrote:
>> >>> On Fri, Jul 19, 2013 at 8:19 PM, Grant Likely <grant.likely@linaro.org> wrote:
>> >>> > Device tree bindings require a lot more attention than they used to.
>> >>> > We've got a group of volunteers willing to take over maintaining
>> >>> > bindings. This patch adds them to the MAINTAINERS file.
>> >> []
>> >>> > diff --git a/MAINTAINERS b/MAINTAINERS
>> >> []
>> >>> > +OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS
>> >> []
>> >>> > +F:     arch/*/
>> >> []
>> >>> This seems a bit broad.
>> >>
>> >> Yep, that's every file anywhere under arch.
>> >
>> > yeah, that was a c/p mistake. I'll drop that line before committing.
>>
>> In fact, if things go well with the schema tool, it would be possible
>> to leave out the .dts files entirely as far as binding review goes.
>> The binding would be the important part and the .dts files would be
>> checked against that. That's something for the future though.
>
> btw: please add a terminating slash to
>      the file pattern directories
>
> +F:     Documentation/devicetree/
> +F:     arch/*/boot/dts/
> +F:     include/dt-bindings/

Done.

g.
