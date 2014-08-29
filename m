Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaH2H3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:29:54 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:57594 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbaH2H3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:29:51 -0400
MIME-Version: 1.0
In-Reply-To: <1408716062-26055-3-git-send-email-nm@ti.com>
References: <1408716062-26055-1-git-send-email-nm@ti.com>
	<1408716062-26055-3-git-send-email-nm@ti.com>
Date: Fri, 29 Aug 2014 09:29:51 +0200
Message-ID: <CACRpkdZafNeL+mmeOVfbEJFFAtYSbOV74rPHWZZrr6DsfeD-Yw@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: single: Add DRA7 pinctrl compatibility
From: Linus Walleij <linus.walleij@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>,
        =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dave Gerlach <d-gerlach@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 4:01 PM, Nishanth Menon <nm@ti.com> wrote:

> DRA7 pinctrl definitions now differ from traditional 16 bit OMAP pin
> ctrl definitions, in that all 32 bits are used to describe a single pin
>
> Also the location of wakeupenable and event bits have changed.
>
> Signed-off-by: Nishanth Menon <nm@ti.com>

Patch applied with Tony's ACK.

Yours,
Linus Walleij
