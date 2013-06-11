Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab3FKIxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 04:53:45 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:37749 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab3FKIxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 04:53:44 -0400
MIME-Version: 1.0
In-Reply-To: <201306102216.23292.heiko@sntech.de>
References: <201306102139.32444.heiko@sntech.de>
	<201306102142.52644.heiko@sntech.de>
	<201306102216.23292.heiko@sntech.de>
Date: Tue, 11 Jun 2013 10:53:43 +0200
Message-ID: <CACRpkdaLq_sDq1v=_K20fj7nJ42-PssBUv+t__DsnTcn3Py2uw@mail.gmail.com>
Subject: Re: [PATCH 2/2 v3] pinctrl: add pinctrl driver for Rockchip SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 10:16 PM, Heiko Stübner <heiko@sntech.de> wrote:

> This driver adds support the Cortex-A9 based SoCs from Rockchip,
> so at least the RK2928, RK3066 (a and b) and RK3188.
> Earlier Rockchip SoCs seem to use similar mechanics for gpio
> handling so should be supportable with relative small changes.
> Pull handling on the rk3188 is currently a stub, due to it being
> a bit different to the earlier SoCs.
>
> Pinmuxing as well as gpio (and interrupt-) handling tested on
> a rk3066a based machine.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
> changes since v2:
> Found out how to handle the phandle in the regular rockchip,pins property
> 5 minutes after sending the v2 ... damn :-) .
> I'm terribly sorry for all the noise.
>
>
> After Stephen Warren's clarification, again with <dt-bindings/...> include.
> and of course adapted to the new expected dt node-structure

Thanks, this v3 version applied.

And don't worry about the noise, it is normal in situations like these
where we're seeing rapid development of core stuff and building
consensus.

Yours,
Linus Walleij
