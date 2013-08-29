Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab3H2Her (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:34:47 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33151 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab3H2Heq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:34:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130829171704.7a7630dd19d19ccdb9aaf384@canb.auug.org.au>
References: <20130829171704.7a7630dd19d19ccdb9aaf384@canb.auug.org.au>
Date: Thu, 29 Aug 2013 09:34:45 +0200
Message-ID: <CACRpkdaPsV8OePLn0gOC8wc5Ew94KL1CUmngdrdF4M++xk9Ekg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the pinctrl tree with Linus' tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Sherman Yin <syin@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 9:17 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Linus,
>
> Today's linux-next merge of the pinctrl tree got a conflict in
> drivers/pinctrl/pinctrl-sunxi.c between commit 1bee963db9dd ("pinctrl:
> sunxi: Add spinlocks") from Linus' tree and commit 03b054e9696c
> ("pinctrl: Pass all configs to driver on pin_config_set()") from the
> pinctrl tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Hm yeah I think I should just merge in the latest -rc to smoothen
this over, as both conflicting patches come from my tree...

Yours,
Linus Walleij
