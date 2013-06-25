Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab3FYCom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 22:44:42 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:44163 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3FYCol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 22:44:41 -0400
MIME-Version: 1.0
In-Reply-To: <51C8E637.2060106@codeaurora.org>
References: <1372118615-14805-1-git-send-email-festevam@gmail.com>
	<51C8E637.2060106@codeaurora.org>
Date: Mon, 24 Jun 2013 23:44:40 -0300
Message-ID: <CAOMZO5CzphELkwr8gGP1LfA3HJ02CZpnzneETaZcn9YXws=ieQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: mach-clps711x: common: Use linux/sched_clock.h
From: Fabio Estevam <festevam@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: john.stultz@linaro.org, tglx@linutronix.de, shc_work@mail.ru,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 9:37 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> Is this one in the arm-soc tree? I plan to make a sweep after 3.11-rc1

I haven't see a fix for this in the linux-arm-kernel list.

> and fix up all the stragglers (looks like just this one) and remove the
> dummy asm header that just got merged into the tip tree.

There was another one and Thomas has already applied it:
http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=2699339361a9bacb3fa663e6b8981a040cfca4ee
