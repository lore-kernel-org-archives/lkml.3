Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3KKKBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 05:01:08 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:38538 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3KKKA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 05:00:58 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "christian.ruppert@abilis.com" <christian.ruppert@abilis.com>
Subject: Re: [GIT PULL] pin control bulk changes for v3.13
Thread-Topic: [GIT PULL] pin control bulk changes for v3.13
Thread-Index: AQHO3sEiKrO36hVs10O31J+CRXvZFg==
Date: Mon, 11 Nov 2013 10:00:53 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075155D9F@IN01WEMBXA.internal.synopsys.com>
References: <CACRpkdYpuZec_JRAPYZHmB5qTYebKR6iBy5=RvBUUEXsuOu97Q@mail.gmail.com>
	<52808D34.70309@synopsys.com>
 <CACRpkdaRGKBWr+rtOD3tWBUA452yApF838ufZ6nPOhzMZGDzfg@mail.gmail.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.15.84.232]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 03:03 PM, Linus Walleij wrote:
> On Mon, Nov 11, 2013 at 8:54 AM, Vineet Gupta
> <Vineet.Gupta1@synopsys.com> wrote:
>> On 11/11/2013 12:14 PM, Linus Walleij wrote:
>>> - Add the Abilis TB10x pin control driver used on the ARC
>>>   architecture. Also the corresponding GPIO driver is merged
>>>   through this tree, so the ARC has full support for pins
>>>   and GPIOs after this.
>> Only the actual DT changes in arch/arc/plat-tb10x are missing which will require a
>> 2nd pull request for ARC for rc1 which could have been avoided had I bitched about
>> it earlier.
> Actually I think device tree changes - if you mean changes to this platform's
> DTS/DTSI files, should go through the ARC arch tree.

But current workflow is prone to broken bisectability - arch maintainers need to
make sure that the core/driver changes hit mainline before the actual dts/dtsi
files in arch/*

> As the idea is to eventually move the DTS stuff out of the kernel we should
> not try to couple these into the subsystem trees.

IMHO putting the 2 parts in a patch series and routing via the same subsys tree
will not really couple them. I fail to see how u would use the commits in driver/*
(or not use the commits in arch/*) to do the proposed seperation of future.

> Bindings Documentation/devicetree/bindings/* should go through the
> subsystem trees though.

Agreed !

-Vineet


