Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbaEIK6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:58:50 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:40487 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaEIK6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:58:48 -0400
MIME-Version: 1.0
In-Reply-To: <8d517ae1adc265643ff9de4b1a2d1b65a4bb6997.1398844809.git.toby@tismith.id.au>
References: <cover.1398844809.git.toby@tismith.id.au>
	<8d517ae1adc265643ff9de4b1a2d1b65a4bb6997.1398844809.git.toby@tismith.id.au>
Date: Fri, 9 May 2014 12:58:48 +0200
Message-ID: <CACRpkdZC5_5J1cA6_OVmp9TdT0JW7vBPSqk3SJxjuqkCCFMobA@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: pca953x: request a shared interrupt
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

> Request a shared interrupt when requesting a pca953x GPIO interrupt
>
> Signed-off-by: Toby Smith <toby@tismith.id.au>

Patch applied.

Yours,
Linus Walleij
