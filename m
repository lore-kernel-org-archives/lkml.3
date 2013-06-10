Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab3FJVFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:05:10 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:52785 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab3FJVFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:05:09 -0400
MIME-Version: 1.0
In-Reply-To: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Jun 2013 23:05:08 +0200
Message-ID: <CAPDyKFrJumd79hHWJkGWvRKzhoaprPHu=U6HOHXzVL8WyNS6jw@mail.gmail.com>
Subject: Re: [PATCH 00/21] ARM: ux500: Enable Clock look-up from Device Tree
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 June 2013 15:42, Lee Jones <lee.jones@linaro.org> wrote:
> Nice and simple implementation using standard Clk APIs.
Hi Lee,

I may be a bit tired, but I am having a bit hard to follow the steps
taken in this patch set. :-)

I should of course tell you why:
1. You start out by adding DT definitions in the DT files, should that
not be done as the final step, after the DT support has been added in
ux500 clk driver?
2. Moreover, I think it would be enough to group the definitions
patches into one patch or at least significant fewer. Same feeling
about the patches were you remove the AUXDATA, this would simplify the
review for me.
3. The rest will be commented per patch.

Kind regards
Ulf Hansson

>
>  arch/arm/boot/dts/dbx5x0.dtsi    |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  arch/arm/boot/dts/snowball.dts   |    3 ++-
>  arch/arm/mach-ux500/cpu-db8500.c |   36 +--------------------------
>  drivers/clk/ux500/u8500_clk.c    |  154 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 249 insertions(+), 38 deletions(-)
>
>
