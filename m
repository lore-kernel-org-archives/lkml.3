Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3KTNh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:37:27 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:48565 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3KTNhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:37:22 -0500
MIME-Version: 1.0
In-Reply-To: <20131120002317.27342.34257.sendpatchset@w520>
References: <20131120002259.27342.35575.sendpatchset@w520>
	<20131120002317.27342.34257.sendpatchset@w520>
Date: Wed, 20 Nov 2013 14:37:22 +0100
Message-ID: <CACRpkdYQB0eMHhE-Y1mgnaeoyLOJxLEdzbeo9eh=tmhNn6XkKg@mail.gmail.com>
Subject: Re: [PATCH 02/05 v2] gpio: rcar: Enable mask on suspend
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 1:23 AM, Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@opensource.se>
>
> Now when lazy interrupt disable has been enabled in the driver
> then extend the code to set IRQCHIP_MASK_ON_SUSPEND which tells
> the core that only IRQs marked as wakeups need to stay enabled
> during Suspend-to-RAM.
>
> Tested on the Lager board with GPIO-keys and Suspend-to-RAM.
>
> Signed-off-by: Magnus Damm <damm@opensource.se>

Patch applied.

Yours,
Linus Walleij
