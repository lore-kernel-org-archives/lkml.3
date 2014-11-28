Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaK1N5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:57:30 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:63918 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaK1N53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:57:29 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdaVfJnMZEnEmm2VP+qO0uaoj9NvNNwcd44qoRkwP59tSA@mail.gmail.com>
References: <1416977280-27319-1-git-send-email-rebecca.swee.fun.chang@intel.com>
	<1416977280-27319-2-git-send-email-rebecca.swee.fun.chang@intel.com>
	<CACRpkdaVfJnMZEnEmm2VP+qO0uaoj9NvNNwcd44qoRkwP59tSA@mail.gmail.com>
Date: Fri, 28 Nov 2014 14:57:28 +0100
Message-ID: <CACRpkdbqScGF5WvbOfq5z9b1ga-_rQBvvC5+ZAf6eEKMbyUytQ@mail.gmail.com>
Subject: Re: [PATCHv4 1/3] gpio: sch: Consolidate similar algorithms
From: Linus Walleij <linus.walleij@linaro.org>
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Denis Turischev <denis.turischev@compulab.co.il>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 2:54 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> 2014-11-26 5:47 GMT+01:00 Chang Rebecca Swee Fun
> <rebecca.swee.fun.chang@intel.com>:
>
>> Consolidating similar algorithms into common functions to make
>> GPIO SCH simpler and manageable.
>>
>> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
>
> Patch already applied. If you changed anything, send incremental
> patches on top of my devel branch or linux-next or something...

Bah it was *NOT* already applied. But it doesn't apply so please rebase
the patch set to my "devel" branch in the GPIO tree and resend.

Yours,
Linus Walleij
