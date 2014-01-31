Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaAaLg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 06:36:58 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:46781 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbaAaLg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 06:36:57 -0500
MIME-Version: 1.0
In-Reply-To: <1390818236-13531-2-git-send-email-sonic.adi@gmail.com>
References: <1390818236-13531-1-git-send-email-sonic.adi@gmail.com>
	<1390818236-13531-2-git-send-email-sonic.adi@gmail.com>
Date: Fri, 31 Jan 2014 12:36:56 +0100
Message-ID: <CACRpkdYbcuSs7AJiX18xG=XTbLAHQHXiVXbaAyhB=Zgc0YpE6g@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl-adi2: change irq_base from usigned int to int
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 11:23 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Negative irq_base means this gpio port doens't support interrupts.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

Patch applied.

Yours,
Linus Walleij
