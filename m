Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab3A0WLc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 17:11:32 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59815 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab3A0WL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 17:11:29 -0500
MIME-Version: 1.0
In-Reply-To: <201301202124.BFJ81722.SFOHtJFOLQFVOM@I-love.SAKURA.ne.jp>
References: <201301202124.BFJ81722.SFOHtJFOLQFVOM@I-love.SAKURA.ne.jp>
Date: Sun, 27 Jan 2013 23:11:29 +0100
Message-ID: <CACRpkdbvW4hyNJYVg7gUE4XCz-d6Dt75BU=acSORpeGP7os6rA@mail.gmail.com>
Subject: Re: [3.8-rc4 arm] SCSI_SYM53C8XX_2 module cannot register IRQ
From: Linus Walleij <linus.walleij@linaro.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        rmk+kernel@arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 1:24 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:

> I'm experiencing two regressions in 3.8-rcX.
>
> Regression:
>
>   (1) Console shows nothing, which makes it impossible to determine whether
>       the system is working or not.
>
>   (2) SCSI_SYM53C8XX_2 cannot register IRQ, showing below messages upon load.
>
>       PCI: enabling device 0000:00:0c.0 (0100 -> 0103)
>       sym0: <895a> rev 0x0 at pci 0000:00:0c.0 irq 27
>       sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
>       sym0: request irq 27 failure
>       sym0: giving up ...

I think I've fixed it now, mailed out a patch. Please test this and confirm
if it fixes your problem!

Yours,
Linus Walleij
