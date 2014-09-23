Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaIWJqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:46:22 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:39570 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbaIWJqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:46:21 -0400
MIME-Version: 1.0
In-Reply-To: <6d676a88eb82a47f8fa9e16abbc768e3e9ac236a.1410020458.git.stefan@agner.ch>
References: <cover.1410020458.git.stefan@agner.ch>
	<6d676a88eb82a47f8fa9e16abbc768e3e9ac236a.1410020458.git.stefan@agner.ch>
Date: Tue, 23 Sep 2014 11:46:20 +0200
Message-ID: <CACRpkdbzvyN0ecP2JA6LhYkPYhe_vJTrLvx4WOW73SRyoMLPEg@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: imx: detect uninitialized pins
From: Linus Walleij <linus.walleij@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: Alexandre Courbot <gnurou@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2014 at 6:25 PM, Stefan Agner <stefan@agner.ch> wrote:

> The pinctrl driver initialized the register offsets for the pins
> with 0. On Vybrid an offset of 0 is a valid offset for the pinctrl
> mux register. So far, this was solved using the ZERO_OFFSET_VALID
> flag which allowed offsets of 0. However, this does not allow to
> verify whether a pins struct imx_pmx_func was initialized or not.
>
> Use signed offset values for register offsets and initialize those
> with -1 in order to detect uninitialized offset values reliable.
>
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Patch applied.

Yours,
Linus Walleij
