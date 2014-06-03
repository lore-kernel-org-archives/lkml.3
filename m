Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaFCLVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:21:11 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:61971 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaFCLVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:21:10 -0400
MIME-Version: 1.0
In-Reply-To: <1401726478-14879-1-git-send-email-grygorii.strashko@ti.com>
References: <1401726478-14879-1-git-send-email-grygorii.strashko@ti.com>
Date: Tue, 3 Jun 2014 13:21:09 +0200
Message-ID: <CACRpkda7EEJNmfjHseQP9ChQ+OJf62qe=aBy3FJ-EFPGO1r6cg@mail.gmail.com>
Subject: Re: [PATCH-next] mfd: ab8500: fix dt irq mapping
From: Linus Walleij <linus.walleij@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Rob Herring <robh@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 6:27 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:

> The AD8500 defines itself as interrupt-controller in DT,
> but it doesn't assign DT node to IRQ domain when creates it.
> As result, of_irq_xx() helpers don't work because they can't
> find necessary IRQ domain.
>
> Hence, fix it by assigning AD8500 core device DT node to IRQ
> domain when it's created.
>
> This patch fixes STE u8500 Snowball boot failure reported by Kevin Hilman
> https://lkml.org/lkml/2014/5/27/624
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Reported-and-tested-by: Kevin Hilman <khilman@linaro.org>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
