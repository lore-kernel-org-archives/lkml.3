Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3KKJd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 04:33:57 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:34204 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3KKJdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:33:49 -0500
MIME-Version: 1.0
In-Reply-To: <52808D34.70309@synopsys.com>
References: <CACRpkdYpuZec_JRAPYZHmB5qTYebKR6iBy5=RvBUUEXsuOu97Q@mail.gmail.com>
	<52808D34.70309@synopsys.com>
Date: Mon, 11 Nov 2013 10:33:49 +0100
Message-ID: <CACRpkdaRGKBWr+rtOD3tWBUA452yApF838ufZ6nPOhzMZGDzfg@mail.gmail.com>
Subject: Re: [GIT PULL] pin control bulk changes for v3.13
From: Linus Walleij <linus.walleij@linaro.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "christian.ruppert@abilis.com" <christian.ruppert@abilis.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 8:54 AM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
> On 11/11/2013 12:14 PM, Linus Walleij wrote:

>> - Add the Abilis TB10x pin control driver used on the ARC
>>   architecture. Also the corresponding GPIO driver is merged
>>   through this tree, so the ARC has full support for pins
>>   and GPIOs after this.
>
> Only the actual DT changes in arch/arc/plat-tb10x are missing which will require a
> 2nd pull request for ARC for rc1 which could have been avoided had I bitched about
> it earlier.

Actually I think device tree changes - if you mean changes to this platform's
DTS/DTSI files, should go through the ARC arch tree.

As the idea is to eventually move the DTS stuff out of the kernel we should
not try to couple these into the subsystem trees.

Bindings Documentation/devicetree/bindings/* should go through the
subsystem trees though.

Yours,
Linus Walleij
