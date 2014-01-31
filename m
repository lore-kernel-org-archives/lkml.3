Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbaAaLf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 06:35:57 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:49712 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186AbaAaLf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 06:35:56 -0500
MIME-Version: 1.0
In-Reply-To: <1390818236-13531-1-git-send-email-sonic.adi@gmail.com>
References: <1390818236-13531-1-git-send-email-sonic.adi@gmail.com>
Date: Fri, 31 Jan 2014 12:35:55 +0100
Message-ID: <CACRpkdbZuTuS-e4=Kx3ykVrBT=y8oTqxfHaG_pyU9ET0_=qT0A@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: Move pint PM storage structure out of
 blackfin architecture.
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
> It is better to keep this structure in the pinctrl-adi2 driver.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

Seems like a good idea, patch applied.
(Steven, complain if any problem.)

Yours,
Linus Walleij
