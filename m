Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab3I0MWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:22:18 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:46069 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab3I0MWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:22:15 -0400
MIME-Version: 1.0
In-Reply-To: <1379928588-12627-1-git-send-email-sonic.adi@gmail.com>
References: <1379928588-12627-1-git-send-email-sonic.adi@gmail.com>
Date: Fri, 27 Sep 2013 14:22:15 +0200
Message-ID: <CACRpkdadtUJ=qe6Ffu9J9HLVKc0sZPDbG8FT0ryMYizPwErhBA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-adi2: Remove nested lock+irqsave that
 resue flags.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 11:29 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Also avoid use NULL pointer in error message.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

Sonic are you respinning this with fixes to Dan's remarks?

You may need to rebase the patch on my devel branch as
Axel fixed one of the problems (if I get it right).

Yours,
Linus Walleij
