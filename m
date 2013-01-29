Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab3A2XDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 18:03:48 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59843 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3A2XDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 18:03:46 -0500
MIME-Version: 1.0
In-Reply-To: <1359047682.21576.154.camel@gandalf.local.home>
References: <1359047682.21576.154.camel@gandalf.local.home>
Date: Wed, 30 Jan 2013 00:03:45 +0100
Message-ID: <CACRpkdZU80XB2GiDtc7nh0hgMpyVYesi+xwhndu50jGS1L=wiw@mail.gmail.com>
Subject: Re: [BUG] snowball board locks up on boot
From: Linus Walleij <linus.walleij@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>, Lee Jones <lee.jones@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 6:14 PM, Steven Rostedt <rostedt@goodmis.org> wrote:

> I tried to get my snowball board working on the latest kernel, but it
> locks up hard very early on boot up.
>
> I bisected it down to this commit:
>
> commit ebc96db7632f987e0b9bffcb782cf5cfb8afb0dd
> Author: Ulf Hansson <ulf.hansson@linaro.org>
> Date:   Mon Aug 27 15:45:53 2012 +0200
>
>     ARM: ux500: Switch to use common clock framework

Yeah the new common clock framework is a bit like a heart
transplant on the platforms you convert, some fallout is expected.

However I thought we had all the clk fixes covered by -rc4 :-(

I don't have a Snowball right now myself, so have to ask
for help here (non snowball ux500's work just fine for me).

Lee, are you still booting the Snowball on new kernels
everyday, and do you know if some fix is still missing?

Yours,
Linus Walleij
