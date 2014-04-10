Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030546AbaDJRTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:19:20 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:62358 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030525AbaDJRTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:19:17 -0400
MIME-Version: 1.0
In-Reply-To: <1396532687.15484.3.camel@phoenix>
References: <1396532687.15484.3.camel@phoenix>
Date: Thu, 10 Apr 2014 19:19:16 +0200
Message-ID: <CACRpkdY+xLDZ3+ja+t9YVUmyMukGAZdiukWMNNi7whNEQs6jsw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: adi2: Statize adi_gpio_irq_domain_ops
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 3:44 PM, Axel Lin <axel.lin@ingics.com> wrote:

> It's only referenced in this file, make it static.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Patch applied.

Yours,
Linus Walleij
