Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab3FDJFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:05:21 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:61045 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3FDJFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:05:19 -0400
MIME-Version: 1.0
In-Reply-To: <1369920465-13905-6-git-send-email-fabio.baltieri@linaro.org>
References: <1369920465-13905-1-git-send-email-fabio.baltieri@linaro.org>
	<1369920465-13905-6-git-send-email-fabio.baltieri@linaro.org>
Date: Tue, 4 Jun 2013 11:05:18 +0200
Message-ID: <CACRpkdYTt+0AmqV62WWfLLQE24a7=q0Ahdcm9QLRy6wPSG4MdA@mail.gmail.com>
Subject: Re: [PATCH 5/5] mfd: ab8500-core: Add of_compatible property for ab8500-codec
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 3:27 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> Add of_compatible string to the ab8500-codec cell to allow the driver to
> grab handlers such as regulators from device-tree when available.
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I think Lee is queueing ab8500 patches for Sam these days
to smoothen things, so letting him pick this up.

Yours,
Linus Walleij
