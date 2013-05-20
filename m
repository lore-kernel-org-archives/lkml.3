Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab3ETSPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 14:15:45 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:62785 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab3ETSPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 14:15:44 -0400
MIME-Version: 1.0
In-Reply-To: <1367244438-5322-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1367244438-5322-1-git-send-email-maxime.ripard@free-electrons.com>
Date: Mon, 20 May 2013 20:15:43 +0200
Message-ID: <CACRpkdbXHvhnmk=QfmmZiYwdVedP2P5zY12cqRtb6QfYCu3o=A@mail.gmail.com>
Subject: Re: [PATCH] gpio: mxs: Use set and clear capabilities of the gpio controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 4:07 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> The current driver doesn't use the set and clear registers found on the
> mxs gpio controller.
>
> This leads the generic gpio controller to be using some internal value
> to avoid looking up the value stored in the registers, making it behave
> pretty much like a cache.
>
> This raises some coherency problem when a gpio is not modified by the
> gpio controller, while it can easily be fixed by using the set and clear
> registers.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Patch applied for rc-fixes with Shawns ACK.

Yours,
Linus Walleij
