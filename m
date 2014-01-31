Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbaAaLk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 06:40:58 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:51255 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbaAaLk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 06:40:56 -0500
MIME-Version: 1.0
In-Reply-To: <1390872738-822-1-git-send-email-markus.mayer@linaro.org>
References: <1390872738-822-1-git-send-email-markus.mayer@linaro.org>
Date: Fri, 31 Jan 2014 12:40:56 +0100
Message-ID: <CACRpkdYjErY-A-1U=QRas5jXH7SS8mteX2uxe_3HdcrVBCJisg@mail.gmail.com>
Subject: Re: [PATCH] gpio: bcm281xx: Use "unsigned gpio" consistently
 throughout the code
From: Linus Walleij <linus.walleij@linaro.org>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Linaro Patches <patches@linaro.org>,
        Linux GPIO List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tim Kryger <tim.kryger@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 2:32 AM, Markus Mayer <markus.mayer@linaro.org> wrote:

> This patch removes some inconsistencies caused by the use of "int gpio"
> in some parts of the code and "unsigned gpio" in others.
>
> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Tim Kryger <tim.kryger@linaro.org>

Patch applied, nice for static syntax checkers.

But the variable should probably be renamed from
"gpio" to "offset" since it's a local offset number on this
very GPIO block, not the global GPIO numberspace.

No big deal though.

Yours,
Linus Walleij
