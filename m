Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbaHKTvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:51:43 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:41085 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaHKTvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:51:41 -0400
Date: Mon, 11 Aug 2014 12:51:37 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: torvalds@linux-foundation.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, robherring2@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>
Subject: Re: [GIT PULL 2/7] ARM: SoC platform changes for 3.17
Message-ID: <20140811195137.GB3711@ld-irv-0074>
References: <1407516479-1251-1-git-send-email-olof@lixom.net>
 <1407516479-1251-3-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407516479-1251-3-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ other involved parties

On Fri, Aug 08, 2014 at 09:47:54AM -0700, Olof Johansson wrote:
> This is the bulk of new SoC enablement and other platform changes for 3.17:
[...]
> * Broadcom BCM7xxx settop box chipset is introduced
[...]
> Marc Carino (1):
>       ARM: brcmstb: add infrastructure for ARM-based Broadcom STB SoCs

I realize this is a bit late (the pull request is already merged), but
I'd like to be up-front about this: there were some (late) oustanding
review comments made on this patch [1]. I have a few patches queued
locally for addressing many of them, but not all of the issues are
completely resolved.

Shall I simply send a revert patch for the
arch/arm/mach-bcm/platsmp-brcmstb.c stuff, and get it in through the
bcm -> arm-soc -> Linus merge path in 3.17-rcX? Or should I take the
incremental improvement approach, as we have functioning code with no
clear alternative proposal yet?

Again, sorry for the late noise.

Brian

[1] version 8 patch:

      http://article.gmane.org/gmane.linux.ports.arm.kernel/343391
