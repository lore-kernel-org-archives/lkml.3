Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3KSI0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:26:48 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:64835 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab3KSI0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:26:47 -0500
MIME-Version: 1.0
In-Reply-To: <20131113225927.21449.78044.sendpatchset@w520>
References: <20131113225927.21449.78044.sendpatchset@w520>
Date: Tue, 19 Nov 2013 09:26:47 +0100
Message-ID: <CACRpkdYZ07wrGiHtFww4TExUM8Ny13OtQZBQ3XqLc-hUC+-5+A@mail.gmail.com>
Subject: Re: [PATCH 00/03] gpio: R-Car and EM GPIO update
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 11:59 PM, Magnus Damm <magnus.damm@gmail.com> wrote:

> gpio: R-Car and EM GPIO update
>
> [PATCH 01/03] gpio: rcar: Use lazy disable and mask on suspend
> [PATCH 02/03] gpio: em: Setup gpiochip->dev
> [PATCH 03/03] gpio: em: Use lazy disable and mask on suspend
>
> Update the R-Car GPIO driver and the GPIO driver used on EMEV2 to use lazy
> disable and mask on suspend. This fixes the Suspend-to-RAM behavior to make
> sure wakeup sources are left enabled while suspending. Also include a small
> fix for gpio-em that fixes the DT use case.
>
> Signed-off-by: Magnus Damm <damm@opensource.se>

These look OK but I see you and Laurent are discussing
patch 1, so whenever you feel ready with the series, please
resend so I can apply it.

Yours,
Linus Walleij
