Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab3FQJ1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:27:39 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:35144 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716Ab3FQJ1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:27:38 -0400
MIME-Version: 1.0
In-Reply-To: <1371218953-31777-1-git-send-email-vdonnefort@gmail.com>
References: <1371218953-31777-1-git-send-email-vdonnefort@gmail.com>
Date: Mon, 17 Jun 2013 11:27:37 +0200
Message-ID: <CACRpkdZ85oFiWEOQXSWXiq3z5wwZJFBbYM_rHqSmrCOPQobwbQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: ich: add GPO_BLINK support
From: Linus Walleij <linus.walleij@linaro.org>
To: Vincent Donnefort <vdonnefort@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Peter Tyser <ptyser@xes-inc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Guinot <simon.guinot@sequanux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 4:09 PM, Vincent Donnefort <vdonnefort@gmail.com> wrote:

> This patch makes sure blink hardware is disabled for selected GPIO. Blink
> hardware is controled by GPO_BLINK register and is available for GPIOs from 0
> to 31.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>

Patch looks OK but does not apply on my current GPIO
tree, i.e. this:
https://git.kernel.org/cgit/linux/kernel/git/linusw/linux-gpio.git/commit/?h=next

Care to rebase it?

Yours,
Linus Walleij
