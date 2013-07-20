Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab3GTUyo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 16:54:44 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:59232 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab3GTUym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 16:54:42 -0400
MIME-Version: 1.0
In-Reply-To: <1374178035-19943-1-git-send-email-davidb@codeaurora.org>
References: <1374178035-19943-1-git-send-email-davidb@codeaurora.org>
Date: Sat, 20 Jul 2013 22:54:42 +0200
Message-ID: <CACRpkdbOO8fFEx+PxsdJ9F1dqD6V4_RPZThvTufo9+XhhyuHOg@mail.gmail.com>
Subject: Re: [PATCH 0/3] MSM gpio fixes
From: Linus Walleij <linus.walleij@linaro.org>
To: David Brown <davidb@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-gpio@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 10:07 PM, David Brown <davidb@codeaurora.org> wrote:

> Rohit sent these three fixes out on June 18.  I still need a
> devicetree ack for the first patch, and would like these to get pulled
> in for v3.11
>
> Rohit Vaswani (3):
>   ARM: msm: dts: Fix the gpio register address for msm8960
>   drivers: gpio: msm: Fix the error condition for reading ngpio

OK for these two...

>   ARM: msm: Consolidate gpiomux for older architectures

This does not look like a fix? Surely this can wait for v3.12?

Yours,
Linus Walleij
