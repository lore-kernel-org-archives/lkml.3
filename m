Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaGBJaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:30:10 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54084 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaGBJaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:30:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140702052012.23338.54536@quantum>
References: <1404061055-89797-1-git-send-email-manuel.lauss@gmail.com>
 <1404061055-89797-3-git-send-email-manuel.lauss@gmail.com> <20140702052012.23338.54536@quantum>
From: Manuel Lauss <manuel.lauss@gmail.com>
Date: Wed, 2 Jul 2014 11:29:27 +0200
Message-ID: <CAOLZvyH810_0yp=CaQjxYianguS++iXOmq6ZEW2FWRPDxZMW2g@mail.gmail.com>
Subject: Re: [PATCH 2/2] MIPS: Alchemy: common clock framework integration
To: Mike Turquette <mturquette@linaro.org>
Cc: Linux-MIPS <linux-mips@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Wed, Jul 2, 2014 at 7:20 AM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Manuel Lauss (2014-06-29 09:57:35)
>> Expose chip-internal configurable clocks to the common clk framework,
>> and fix a few drivers to take advantage of it.
>
> Thanks for the patch series! Both patches cover a lot of ground, but
> I'll focus on #2. It would be best to split the driver changes out

I sent the first one along because the second doesn't compile without it.


> separately. You can introduce the common clk changes but not compile
> them in, then change the drivers, then add the logic to compile the new
> common clock driver all as separate patches.

I'll split them into pure clock framework and enablement parts.


> Additionally, it would be cool to push this driver out to drivers/clk/
> if you are so inclined. It looks like your header dependencies are not
> so bad as to make that task impossible. Just a suggestion from me.

This clock framework is for a single line of MIPS SoCs which are no longer
being developed by the manufacturer and I don't think it is reusable for any
other soc line currently in existence.  I'd like to keep it within the mips tree
for that reason.  (I find the ARM way of sprinkling the whole tree with
a single driver for each iteration of each custom on-chip peripheral on
each ARM chip [exaggerated of course] quite messy.   But that's just me).

Manuel
