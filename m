Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3H3E2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:28:00 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:36208 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab3H3E17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:27:59 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH] Kconfig.debug: Add FRAME_POINTER anti-dependency for ARC
Thread-Topic: [PATCH] Kconfig.debug: Add FRAME_POINTER anti-dependency for
 ARC
Thread-Index: AQHOov/erDeR0JeI70CghkAjOCB3Tg==
Date: Fri, 30 Aug 2013 04:25:18 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307514113D@IN01WEMBXA.internal.synopsys.com>
References: <1377592285-21148-1-git-send-email-vgupta@synopsys.com>
 <521F662F.4050003@intel.com>
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

On 08/29/2013 08:48 PM, Dave Hansen wrote:
>
> I assume you're sending this my way since getmaintainer.pl has me tagged
> I moved a bunch of code in there. :)

Indeed :-)

> The Kconfig.debug stuff has no real maintainer.  It would probably be OK
> if you just stick this in your architecture's next git pull request.

Will do, thx.

> Although, it would be nice if someone, at some point, actually
> abstracted that out so that the individual architectures could take care
> of this without editing the main files:
>
> # Kconfig.debug:
>
> config ARCH_FRAME_POINTER_UNAVAILABLE
> 	def_bool y

def_bool n

> ...
> select FRAME_POINTER if !ARCH_FRAME_POINTER_UNAVAILABLE
>
> # arch/.../Kconfig
>
> select ARCH_FRAME_POINTER_UNAVAILABLE

Sure, I was thinking the same. I'll send out a patchset soon, although next week
is gonna be tight due to upcoming merge window.

-Vineet
