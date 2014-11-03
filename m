Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaKCOkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:40:24 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:44680 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaKCOkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:40:22 -0500
MIME-Version: 1.0
In-Reply-To: <f2781e379e3348e39d30cb77b0dbca40@BN1AFFO11FD042.protection.gbl>
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
	<1413479495-14206-9-git-send-email-soren.brinkmann@xilinx.com>
	<CACRpkda9v=H9rQBq484c+UCwEKeca9qOE_78Wf+STB4rDwhuyA@mail.gmail.com>
	<5cf5e2e5cd154992b2896b98988a409a@BN1BFFO11FD007.protection.gbl>
	<CACRpkdZjJQTxVhvq5BT3mHBDHge_wHBNi9N_6u0WVbPB3wBDKw@mail.gmail.com>
	<030ed753d9764825b1bd5c845b360c7d@BN1AFFO11FD036.protection.gbl>
	<CACRpkdb9Gg90GwTpUm7S6SFkFjKTRaZLWa2JLnXJK4H-ZMbQ6A@mail.gmail.com>
	<4a2cb923ab264d7d99107a450d6ddcba@BN1BFFO11FD057.protection.gbl>
	<f2781e379e3348e39d30cb77b0dbca40@BN1AFFO11FD042.protection.gbl>
Date: Mon, 3 Nov 2014 15:40:21 +0100
Message-ID: <CACRpkdZD+wqfxLxMJ+WGvAmaV+XL6bCcLFGD4BuB-0KXum+D_w@mail.gmail.com>
Subject: Re: [PATCH RFC v2 8/8] ARM: zynq: DT: Add pinctrl information
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2014 at 9:20 PM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:
(...)
>                 common {
>                         groups = "uart1_10_grp";
>                         function = "uart1";
>                         bias-pull-up = <0>;
>                         slew-rate = <0>;
>                         io-standard = <1>;
>                 };
>
>                 rx {
>                         pins = "MIO49";
>                         bias-high-impedance = <1>;
>                 };
>
>                 tx {
>                         pins = "MIO48";
>                         bias-high-impedance = <0>;
>                 };
(...)
>                 common {
>                         groups = "uart1_10_grp";
>                         function = "uart1";
>                 };
>
>                 rx {
>                         pins = "MIO49";
>                         slew-rate = <0>;
>                         io-standard = <1>;
>                         bias-high-impedance;
>                 };
>
>                 tx {
>                         pins = "MIO48";
>                         slew-rate = <0>;
>                         io-standard = <1>;
>                 };
>         };
>
> In a nutshell, yes, it's possible to work without the arguments for
> pull-up or tri-state. But it adds complexity in the driver and the DT
> description.

But isn't it obvious that the latter is easier for a human to read
and understand (and not misunderstand) and remember readability
of config is one of the design goals of DT...

Yours,
Linus Walleij
