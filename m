Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3ISMpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:45:25 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:42555 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab3ISMpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:45:24 -0400
MIME-Version: 1.0
In-Reply-To: <1378196941-23390-1-git-send-email-sonic.adi@gmail.com>
References: <1378196941-23390-1-git-send-email-sonic.adi@gmail.com>
Date: Thu, 19 Sep 2013 14:45:23 +0200
Message-ID: <CACRpkdZbB2cq2Ad3Tkoj05DBz4qp7TNSM64tLFv6e6z49bqnKw@mail.gmail.com>
Subject: Re: [PATCH 1/3 v4] pinctrl: ADI PIN control driver for the GPIO
 controller on bf54x and bf60x.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>, Mike Frysinger <vapier@gentoo.org>
Cc: Grant Likely <grant.likely@linaro.org>, Steven Miao <realmz6@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 10:28 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
>
> The new ADI GPIO2 controller was introduced since the BF548 and BF60x
> processors. It differs a lot from the old one on BF5xx processors. So,
> create a pinctrl driver under the pinctrl framework.
(...)
> v4-changes:
(...)

I'm quite happy with v4, and applied it to my devel branch
in the pinctrl tree so we get some rotation in linux-next.

If I can get an ACK from the Blackfin maintainer on patches
2 and 3 I'll apply those as well so you don't have to pull
the pinctrl tree into blackfins tree, Mike?

Yours,
Linus Walleij
