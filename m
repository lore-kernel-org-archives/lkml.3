Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3HWRwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:52:12 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:55917 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab3HWRwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:52:10 -0400
MIME-Version: 1.0
In-Reply-To: <1376953494-9684-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376953494-9684-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1376953494-9684-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Fri, 23 Aug 2013 19:52:10 +0200
Message-ID: <CACRpkdY4k7quQQpRLy0wRzdLYk4Brr64CQJK2BPgsBMLV2k0Yw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] gpio: pcf857x: Remove pdata argument to pcf857x_irq_domain_init()
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 1:04 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:

> The argument is not used, remove it. No board registers a pcf857x device
> with an IRQ without specifying platform data, IRQ domain registration
> behaviour is thus not affected by this change.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Patch applied, unless Kuninori has some objections.

Yours,
Linus Walleij
