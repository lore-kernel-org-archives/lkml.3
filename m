Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763314Ab3DCU20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:28:26 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:39691 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760535Ab3DCU2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:28:24 -0400
MIME-Version: 1.0
In-Reply-To: <515C63F3.5070401@wwwdotorg.org>
References: <1364490685-21831-1-git-send-email-bbasu@nvidia.com>
	<5154827B.8010701@wwwdotorg.org>
	<CACRpkdYLSVkfAxVBMBnkyePujaoQQqB27UiG+-r2APkEDrfLrA@mail.gmail.com>
	<515C63F3.5070401@wwwdotorg.org>
Date: Wed, 3 Apr 2013 22:28:23 +0200
Message-ID: <CACRpkdYcdHHGp9Y7ryPzZgNqsi208c4hPB5yNWsUkEUw2Apd+A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: tegra: add suspend-resume support
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Bibek Basu <bbasu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pritesh Raithatha <praithatha@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 7:16 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> It's possible program the registers so that the same signal is connected
> to (or from depending on signal direction) multiple pins at once. If
> this is done, the behaviour is unspecified; who knows which pin will
> actually receive (or provide) that signal?

In the dbx500 this will actually make the signal come out on both
pins. So there are several muxes connected to the same internal
rail. I can imagine a few odd ways that would work differently though...

We could use this to connect two UARTs to the console, not very
useful, but hey, dual screens...

I wonder what happens if both consoles hit enter at the same instant.
Probably nasty electronic states are possible.

Yours,
Linus Walleij
