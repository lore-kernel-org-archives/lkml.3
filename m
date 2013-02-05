Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3BEPOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:14:01 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:50560 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab3BEPOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:14:00 -0500
MIME-Version: 1.0
In-Reply-To: <1359720305-31933-11-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
	<1359720305-31933-11-git-send-email-blogic@openwrt.org>
Date: Tue, 5 Feb 2013 16:13:51 +0100
Message-ID: <CACRpkdZrd+MiF-+WtyRRgYRAC5LE-CdB8yHaKA+PbftDMYmAYg@mail.gmail.com>
Subject: Re: [PATCH 11/11] PINCTRL: lantiq: fix pin number in ltq_pmx_gpio_request_enable
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: linux-kernel@vger.kernel.org, Thomas Langer <thomas.langer@lantiq.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 1:05 PM, John Crispin <blogic@openwrt.org> wrote:

> The mapping logic inside ltq_pmx_gpio_request_enable() was broken. This only
> effected Falcon SoC.
>
> Signed-off-by: Thomas Langer <thomas.langer@lantiq.com>
> Signed-off-by: John Crispin <blogic@openwrt.org>

Applied as well.

But now I have no longer any clue on if this is a regression
or not...

Yours,
Linus Walleij
