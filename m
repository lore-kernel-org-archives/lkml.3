Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbaEIK5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:57:32 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:47736 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156AbaEIK5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:57:30 -0400
MIME-Version: 1.0
In-Reply-To: <5ca82b7dd4c17ea358a1ea30bb34a3e31828b2b2.1398844809.git.toby@tismith.id.au>
References: <cover.1398844809.git.toby@tismith.id.au>
	<5ca82b7dd4c17ea358a1ea30bb34a3e31828b2b2.1398844809.git.toby@tismith.id.au>
Date: Fri, 9 May 2014 12:57:29 +0200
Message-ID: <CACRpkdZ-reqv=cbfqKcJA5VgCAiUDqTQH+hDoryT0tBiLobsbg@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: pca953x: return IRQ_NONE when appropriate
From: Linus Walleij <linus.walleij@linaro.org>
To: Toby Smith <toby@tismith.id.au>, Aaron Sierra <asierra@xes-inc.com>,
        Graeme Smecher <gsmecher@threespeedlogic.com>,
        Andrew Ruder <andy@aeruder.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 10:01 AM, Toby Smith <toby@tismith.id.au> wrote:

> The irq handler should return IRQ_NONE or IRQ_HANDLED to report
> if we have handled the interrupt.
>
> Signed-off-by: Toby Smith <toby@tismith.id.au>

Patch applied.

Adding some randon pca953x developers to the thread so noone gets
upset.

Yours,
Linus Walleij
