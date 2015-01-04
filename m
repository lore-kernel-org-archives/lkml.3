Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbbADUWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 15:22:38 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:46232 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbbADUWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 15:22:37 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
References: <20150104190123.GA20153@amd>
	<alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
Date: Sun, 4 Jan 2015 12:22:36 -0800
X-Google-Sender-Auth: 9PxsDInnDitWCVuImAbu0hGkZ9s
Message-ID: <CA+55aFxMbicJZXzzHc8=vdwCzhz4kdrmZEKjLadZXr7aySZ4zg@mail.gmail.com>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2015 at 12:03 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
>
> NAK.

To quote the standard response for people who ignore regressions:

  "SHUT THE FUCK UP"

you cannot NAK regression fixes. Seriously.

I don't understand how people can't get this simple thing.

You have two choices:

 - acknowledge and fix regressions

 - get the hell out of kernel development.

It really is that simple. I really don't get why people don't
understand this simple first rule of kernel development. Is it really
not widely enough documented?

No regressions. If user mode breaks, it is absolutely *never*
acceptable to blame user mode.

Occasionally there may be major overriding reasons (security issue,
whatever), but even then we bend over *backwards* trying to make sure
breakage is minimal.

Christ people. Why does this even have to be discussed any more?

And I realize that ARM people may not be used to this whole "user mode
matters" thing, what with all the crazy hardware incompatibilities.
But you guys need to shape up. We don't break things. Not even on ARM.

                          Linus
