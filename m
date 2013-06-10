Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab3FJN5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:57:25 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:43055 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab3FJN5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:57:24 -0400
MIME-Version: 1.0
In-Reply-To: <1370685946-3718-5-git-send-email-maxime.ripard@free-electrons.com>
References: <1370685946-3718-1-git-send-email-maxime.ripard@free-electrons.com>
	<1370685946-3718-5-git-send-email-maxime.ripard@free-electrons.com>
Date: Mon, 10 Jun 2013 15:57:23 +0200
Message-ID: <CACRpkdZfqspUA1BpzMpM727g-s6ckm=PfDkSo8ambUwdW4J8Sw@mail.gmail.com>
Subject: Re: [PATCH 4/4] ARM: sunxi: dt: Register the pio node as interrupt controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 8, 2013 at 12:05 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I guess this patch needs to go through the ARM SoC tree.

Tell me if I can carry it in the pinctrl tree (read: there will be no
conflicts agains changes from elsewhere) and I'll apply it.

Yours,
Linus Walleij
