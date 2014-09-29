Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaI2Iwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:52:34 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33880 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaI2Iwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:52:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140926141943.GC23926@titan.lakedaemon.net>
References: <CACxGe6vCrkHPL6UNy1p8AO4+z5VFRY6w4_2grQEZQwp_3jJ7Yw@mail.gmail.com>
	<CACRpkdZoo=P7uTO1rNDD_HUPjfAk26C0=mNYPoZmTV0wcO3V-w@mail.gmail.com>
	<20140926141943.GC23926@titan.lakedaemon.net>
Date: Mon, 29 Sep 2014 10:52:30 +0200
Message-ID: <CACRpkdYtiRyJK32M2z5EVxW1wXEfv-YDqJ=JPK3TeThV2=7sHA@mail.gmail.com>
Subject: Re: [git pull] Devicetree changes for v3.15
From: Linus Walleij <linus.walleij@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 4:19 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Fri, Sep 26, 2014 at 02:30:53PM +0200, Linus Walleij wrote:

> Exact patch is:
>
>   f4d4ffc03efc kbuild: dtbs_install: new make target
>
>> After this patch a while back I have observed the following behaviour
>> of the kernel build:
>>
>> make zImage
>> make zImage
>> -> incremental build, just relink
>>
>> make zImage
>> make dtbs
>> make zImage
>> -> The whole kernel gets rebuilt
>>
>> So now if I happen to recompile my device trees, I suddenly want
>> the entire zImage to be rebuilt to? It's by definition not changes that
>> affect the kernel build :-(
>>
>> I noticed this because my build scripts calls make dtbs && make zImage,
>> and started to rebuild absolutely everything all the time.
>>
>> Do you think this can be fixed? It's quite simple to reproduce...
>
> Does the attached fix your problem?

Yes!
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Please get this upstream marked for stable.

Yours,
Linus Walleij
