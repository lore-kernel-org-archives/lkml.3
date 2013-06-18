Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab3FRJOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:14:07 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:43031 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab3FRJOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:14:03 -0400
MIME-Version: 1.0
In-Reply-To: <1371545519-27119-1-git-send-email-lee.jones@linaro.org>
References: <1371545519-27119-1-git-send-email-lee.jones@linaro.org>
Date: Tue, 18 Jun 2013 11:14:02 +0200
Message-ID: <CACRpkdbpTMm8FG6KSwvq_7BQRGZ0P=PHHb+WikfRE6JqHv8xpw@mail.gmail.com>
Subject: Re: [PATCH 0/3] ARM: ux500: mop500_snowball_ethernet_clock_enable() removal
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 10:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> As requested by you, this gets rid of  mop500_snowball_ethernet_clock_enable()
> which is no longer in use. It also straightens out a bug which ensures the
> SMSC911x's regulator is turned on at start-up when using Device Tree.
>
> This is based on your test-merge-20130615 branch.

All are Acked-by: Linus Walleij <linus.walleij@linaro.org>

I suggest the ARM SoC folks merge these three patches directly.
I've queued 1/3 and 2/3 on my devicetree branch so they won't
be lost, but 3/3 does not apply on any of my branches, it
needs to be applied directly on some ARM SoC baseline.

Yours,
Linus Walleij
