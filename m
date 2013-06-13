Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab3FMIl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:41:58 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:54340 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758292Ab3FMIlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:41:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130612132713.GE4320@laptop>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
	<20130612132713.GE4320@laptop>
Date: Thu, 13 Jun 2013 10:41:54 +0200
Message-ID: <CACRpkdYtocMN-qvhOX_uHw=zoJysjJhGjQv5gL_ijkR56QL4Bg@mail.gmail.com>
Subject: Re: [PATCH 00/32] ARM: ux500: Enable clocks for Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 3:27 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> After this patchset has been applied, we can request clocks directly
>> from Device Tree without using any AUXDATA device-name hacks. We also
>> take care to remove all of thos at the end of the set.
>
> So it looks like Mike and Grant have okayed the actual design of this
> patch-set, which is great. Is there any chance on some proper Acks from
> Linus and Mike please?

I will get to it. Basically I don't see there is a hurry as this has
no chance to hit the v3.11 merge window anyway so we'll have
lots of time to discuss it.

Why 3.12: my five pull request for ux500 stuff to ARM SoC is still
outstanding, and this stuff will clash with that unless we get
a common merge base. So we have to wait for ARM SoC
to settle at this point.

Yours,
Linus Walleij
