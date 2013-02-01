Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3BAJqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:46:36 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:36543 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab3BAJqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:46:34 -0500
MIME-Version: 1.0
In-Reply-To: <1359211016-24097-4-git-send-email-maxime.ripard@free-electrons.com>
References: <1359211016-24097-1-git-send-email-maxime.ripard@free-electrons.com>
	<1359211016-24097-4-git-send-email-maxime.ripard@free-electrons.com>
Date: Fri, 1 Feb 2013 10:46:33 +0100
Message-ID: <CACRpkdbruAP+sLQ3_v8x=0M6NmLTujWOx1nc8ce7deEOa8M+3Q@mail.gmail.com>
Subject: Re: [PATCH 3/5] ARM: pinctrl: sunxi: Add the pinctrl pin set for
 Allwinner A10
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 3:36 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> Since the Allwinner SoCs variants don't have the same set of pins to
> handle, we need to declare the pin ranges available.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Applied to my allwinner branch.

Thanks,
Linus Walleij
