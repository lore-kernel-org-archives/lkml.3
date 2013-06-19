Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab3FSTO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:14:27 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:39505 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab3FSTO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:14:26 -0400
MIME-Version: 1.0
In-Reply-To: <1371470629-6408-1-git-send-email-vdonnefort@gmail.com>
References: <CACRpkdZ85oFiWEOQXSWXiq3z5wwZJFBbYM_rHqSmrCOPQobwbQ@mail.gmail.com>
	<1371470629-6408-1-git-send-email-vdonnefort@gmail.com>
Date: Wed, 19 Jun 2013 21:14:25 +0200
Message-ID: <CACRpkdY=Xdabr8+2dScBn_XXQ77zLDNk38N5Sub_HWvtQjJnSA@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: ich: add GPO_BLINK support
From: Linus Walleij <linus.walleij@linaro.org>
To: Vincent Donnefort <vdonnefort@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Peter Tyser <ptyser@xes-inc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Guinot <simon.guinot@sequanux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 2:03 PM, Vincent Donnefort <vdonnefort@gmail.com> wrote:

> This patch makes sure blink hardware is disabled for selected GPIO. Blink
> hardware is controled by GPO_BLINK register and is available for GPIOs from 0
> to 31.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>
> ---
> Changes for v2:
>         - Rebased on for-next branch of linux-gpio git tree
>           git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git

Thanks!
Patch applied.

Yours,
Linus Walleij
