Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195AbaLBN0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:26:24 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:54928 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbaLBN0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:26:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuJm_UXHioENBg6himgZkEmopr=T8iCbt0xD6-ds6AHyxA@mail.gmail.com>
References: <1416383487-15993-1-git-send-email-acourbot@nvidia.com>
	<CACRpkdZV-nQPXDnxiBgPTZTpyQ2eiKNL8qJY9jRq=A5foc-xmw@mail.gmail.com>
	<CAMuHMdUQ+rPasUWuGCc0AnV-g6J9zf9HbozuodHaYpy36Khcpg@mail.gmail.com>
	<CAAVeFuJm_UXHioENBg6himgZkEmopr=T8iCbt0xD6-ds6AHyxA@mail.gmail.com>
Date: Tue, 2 Dec 2014 14:26:20 +0100
Message-ID: <CACRpkda9PbzEOpYABFy46pqow2yyhWJ0iE71GhAS61j5odZArw@mail.gmail.com>
Subject: Re: [PATCH] gpio: remove gpio_descs global array
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 2:25 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Tue, Dec 2, 2014 at 7:32 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:

>> This patch changes a return value from -EPROBE_DEFER to -EINVAL in
>> regulator-gpio when a GPIO cannot be found yet, causing probe failures
>> on r8a7791/koelsch:
>
> Hi Geert,
>
> Thanks for signaling this. I think I understand what is going wrong
> and will send a fixup patch in a few minutes.

OK standing by.

Yours,
Linus Walleij
