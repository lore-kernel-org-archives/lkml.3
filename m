Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab3H2IGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 04:06:53 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:62660 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab3H2IGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 04:06:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAJxxZ0O77bgP8_rkRm-EgjAJ45SY2Pd3AGVSMhFxbsfNUmiqGg@mail.gmail.com>
References: <1377066607-19061-1-git-send-email-sonic.adi@gmail.com>
	<52150AD9.3040808@wwwdotorg.org>
	<CAJxxZ0O77bgP8_rkRm-EgjAJ45SY2Pd3AGVSMhFxbsfNUmiqGg@mail.gmail.com>
Date: Thu, 29 Aug 2013 10:06:47 +0200
Message-ID: <CACRpkdbJ+_Kv9FVjxLCjKj++UViq0u3HuPBBx76JrbyuNmppDA@mail.gmail.com>
Subject: Re: [PATCH 1/3 v3] pinctrl: ADI PIN control driver for the GPIO
 controller on bf54x and bf60x.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>,
        Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 9:07 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:

> Is it possible that 2 and more pinctrl devices are on the same SoC? Or
> do we always assume there is only one pinctrl device on one SoC?

It is possible to have N pinctrl devices on the same SoC, not to
mention the whole system. The subsystem does not care, just
line them up.

Yours,
Linus Walleij
