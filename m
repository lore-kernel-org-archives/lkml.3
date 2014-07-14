Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbaGNVS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:18:59 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:63913 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253AbaGNVSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:18:55 -0400
MIME-Version: 1.0
In-Reply-To: <53C3FE0C.4080502@ti.com>
References: <1405116252-53612-1-git-send-email-s-anna@ti.com>
	<CAPdLdq=ZnPBQiGVbKOk8G5soP=uPYpT7mEjigpR=W1Hc4btV3g@mail.gmail.com>
	<53C3FE0C.4080502@ti.com>
Date: Mon, 14 Jul 2014 14:18:54 -0700
Message-ID: <CAPdLdqnd36QQ5v9-owiSFptbdkDxyYXjfRW=PdvaXKUr3B6_pQ@mail.gmail.com>
Subject: Re: [PATCHv2 0/5] OMAP Mailbox framework adoption & DT support
From: Markus Mayer <markus.mayer@linaro.org>
To: Suman Anna <s-anna@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        Dave Gerlach <d-gerlach@ti.com>, Pavel Machek <pavel@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        Device Tree List <devicetree@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

> There are couple of dependent preparatory series. You probably missed
> the following in the cover letter.
>> The series depends on the OMAP mailbox cleanup series [5] and the
>> refreshed OMAP mailbox DT/hwmod cleanup series [2].
>
> As long as you pick the two dependent series, they apply fine on any of
> the 3.16-rcs. I have posted all the series based on 3.16-rc2. Here's a
> merged branch for your reference (not for pulling though, it has one
> additional commit to allow me to test on OMAP2)
> https://github.com/sumananna/mailbox/commits/submit/3.16-rc2-omap-mbox-v8-fwk-v2
>
> The last 2 patches in the series also depend on the mailbox framework
> patches from Jassi to not throw any build errors if enabled.

That worked. Thanks for the pointer. FYI, there is a minor merge
conflict rebasing the series onto 3.16-rc5.

Applying: ARM: OMAP2+: Avoid mailbox legacy device creation for DT-boot
Using index info to reconstruct a base tree...
M arch/arm/mach-omap2/devices.c
Falling back to patching base and 3-way merge...
Auto-merging arch/arm/mach-omap2/devices.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/devices.c
Failed to merge in the changes.
Patch failed at 0029 ARM: OMAP2+: Avoid mailbox legacy device creation
for DT-boot

That's due to this commit:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=1d29a0722f6c38f79785c9ffb911730598de84e2

Regards,
-Markus
