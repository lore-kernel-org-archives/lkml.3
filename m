Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3G2QrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:47:08 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:50919 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab3G2QrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:47:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAJxxZ0OXC46Xcgb+_g00D0NJ_NiHE0eQm+Dg6ze1_93mZqkQPw@mail.gmail.com>
References: <1373972146-12133-1-git-send-email-sonic.adi@gmail.com>
	<CAJxxZ0OXC46Xcgb+_g00D0NJ_NiHE0eQm+Dg6ze1_93mZqkQPw@mail.gmail.com>
Date: Mon, 29 Jul 2013 18:47:04 +0200
Message-ID: <CACRpkdYwNoqQieinZ0Vyji-hsY0UqTHMDSgCL6Y-7M0bxQHPwQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: ADI PIN control driver for the GPIO
 controller on bf54x and bf60x.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, Steven Miao <realmz6@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 6:57 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:

> Could you please comment on this patch set? It is based on your former comments.

I'll get to it. I'm pretty choked right now and actually trying to have
some vacation at the same time.

In the meantime, after glancing over and noting prolific use of the
unlikely() macro, please read the following articles:
http://lwn.net/Articles/70473/
http://lwn.net/Articles/420019/

Yours,
Linus Walleij
