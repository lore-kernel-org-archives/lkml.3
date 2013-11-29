Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab3K2KFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:05:25 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:55274 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3K2KFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:05:20 -0500
MIME-Version: 1.0
In-Reply-To: <1385506004-14943-1-git-send-email-caesarxuchao@gmail.com>
References: <1385506004-14943-1-git-send-email-caesarxuchao@gmail.com>
Date: Fri, 29 Nov 2013 11:05:20 +0100
Message-ID: <CACRpkdZBobnSZMLcW6YWc08ew1sb+UY3np+iS4=nqx5wpSNixw@mail.gmail.com>
Subject: Re: [PATCH V2] gpio: omap: refresh patch "be more aggressive with
 pm_runtime" against v3.12-rc5
From: Linus Walleij <linus.walleij@linaro.org>
To: Chao Xu <caesarxuchao@gmail.com>, ext Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@linaro.org>
Cc: Linux-OMAP <linux-omap@vger.kernel.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 11:46 PM, Chao Xu <caesarxuchao@gmail.com> wrote:

> From: Felipe Balbi <balbi@ti.com>
>
> try to keep gpio block suspended as much as possible.
>
> Tested with pandaboard and a sysfs exported gpio.
>
> Signed-off-by: Felipe Balbi <balbi at ti.com>
>
> [caesarxuchao@gmail.com : Refreshed against v3.12-rc5, and added revision check to enable aggressive pm_runtime on OMAP4-only. Because am33xx_gpio_sysc.idlemodes seems to be wrongly marked as SIDLE_SMART_WKUP, which might cause missed interrupts with this patch. Tested on Pandaboard rev A2.]
>
> Signed-off-by: Chao Xu <caesarxuchao@gmail.com>

I'd like Tony and/or Kevin to have a look at this from a PM point
of view so I get some confirmation from the core maintainers
that this is the way forward.

Yours,
Linus Walleij
