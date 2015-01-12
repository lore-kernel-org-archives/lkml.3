Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbbALJO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:14:59 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:57982 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbbALJOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:14:54 -0500
MIME-Version: 1.0
In-Reply-To: <1418200780-22363-2-git-send-email-gautam.vivek@samsung.com>
References: <1418200780-22363-1-git-send-email-gautam.vivek@samsung.com>
	<1418200780-22363-2-git-send-email-gautam.vivek@samsung.com>
Date: Mon, 12 Jan 2015 10:14:53 +0100
Message-ID: <CACRpkdbtJZ4wKh=wF8t8-NAvi9P1OapP_x61VUdz1WRjSwcYEw@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] pinctrl: exynos: Add BUS1 pin controller for exynos7
From: Linus Walleij <linus.walleij@linaro.org>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kukjin Kim <kgene@kernel.org>,
        root <alim.akhtar@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 9:39 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:

> USB and Power regulator on Exynos7 require gpios available
> in BUS1 pin controller block.
> So adding the BUS1 pinctrl support.
>
> Signed-off-by: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
>
> Changes since V2:
>  - Added documentation on alias for BUS1 pin controller block.

Patch applied with Tomasz ACK.

Yours,
Linus Walleij
