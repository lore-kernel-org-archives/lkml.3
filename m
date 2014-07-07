Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaGGNRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:17:54 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:44541 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaGGNRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:17:52 -0400
MIME-Version: 1.0
In-Reply-To: <1403016777-15121-16-git-send-email-wens@csie.org>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
	<1403016777-15121-16-git-send-email-wens@csie.org>
Date: Mon, 7 Jul 2014 15:17:51 +0200
Message-ID: <CACRpkdZGzEVhEtXhT5KpaR17HWn8gJ=ohG1D_3pdmDSa7XJjTw@mail.gmail.com>
Subject: Re: [PATCH v2 15/20] pinctrl: sunxi: Add A23 R_PIO controller support
From: Linus Walleij <linus.walleij@linaro.org>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 4:52 PM, Chen-Yu Tsai <wens@csie.org> wrote:

> The A23 has a R_PIO pin controller, similar to the one found on the A31 SoC.
> Add support for the pins controlled by the R_PIO controller.
>
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Patch applied.

Yours,
Linus Walleij
