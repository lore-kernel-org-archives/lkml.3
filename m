Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbaDJSOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:14:44 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:55945 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758710AbaDJSOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:14:41 -0400
MIME-Version: 1.0
In-Reply-To: <1397051478-4113-5-git-send-email-boris.brezillon@free-electrons.com>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
	<1397051478-4113-5-git-send-email-boris.brezillon@free-electrons.com>
Date: Thu, 10 Apr 2014 20:14:40 +0200
Message-ID: <CACRpkdYW6b_37V40TRxs=7ecaWuV0X7_YJ4=-Psr9CG-cTb79w@mail.gmail.com>
Subject: Re: [PATCH 04/15] pinctrl: sunxi: specify clk name when retrieving
 pinctrl pio clk
From: Linus Walleij <linus.walleij@linaro.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 3:51 PM, Boris BREZILLON
<boris.brezillon@free-electrons.com> wrote:

> Specify base pio clk name when retrieving it using the CCF.
> This way we will avoid conflicts when introducing a second clk for the A31
> SoC.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Are you merging all these through ARM SoC?

In that case
Acked-by: Linus Walleij <linus.walleij@linaro.org>

If it's OK to merge stand-alone tell me and I'll apply it to
the pinctrl tree.

Yours,
Linus Walleij
