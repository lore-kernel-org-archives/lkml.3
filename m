Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934630Ab3DIIsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:48:32 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:37592 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760088Ab3DIIs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:48:29 -0400
MIME-Version: 1.0
In-Reply-To: <1364389953-20688-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1364389953-20688-1-git-send-email-maxime.ripard@free-electrons.com>
Date: Tue, 9 Apr 2013 10:48:29 +0200
Message-ID: <CACRpkdbESJaYTAONN5UdDEUEVHjh3iJcfrXs2-g61MHi4FouVA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sunxi: Rename wemac functions to emac
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 2:12 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> The pin functions associated to the ethernet controller were introduced
> with the label "wemac", which was the name of the ethernet driver in the
> allwinner source tree, while the real name of the IP is actually "emac",
> as advertised in several documents including the datasheet.
>
> Since this is part of the device tree bindings, and that these part of
> the bindings have not yet be released in a kernel version, it seems like
> the good timing to change it and assure consistency.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Patch applied, thanks!

Yours,
Linus Walleij
