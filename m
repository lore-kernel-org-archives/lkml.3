Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430Ab3BLMNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 07:13:24 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:59454 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759056Ab3BLMNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 07:13:23 -0500
MIME-Version: 1.0
In-Reply-To: <1360550763-5404-1-git-send-email-anilkumar.v@ti.com>
References: <1360550763-5404-1-git-send-email-anilkumar.v@ti.com>
Date: Tue, 12 Feb 2013 13:13:22 +0100
Message-ID: <CACRpkdYGQ3S8-Zfmm8gSU4-R1pr7AZgadRJqSa2diigt4WWpjA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-single: fix the binding documentation
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kumar, Anil" <anilkumar.v@ti.com>, ext Tony Lindgren <tony@atomide.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, b-cousson@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 3:46 AM, Kumar, Anil <anilkumar.v@ti.com> wrote:

> As there are no use of #address-cells and #size-cells properties
> in pinctrl-single driver DT node. Fix pinctrl-single binding documentation
> to remove these properties.
>
> Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
> ---
> Tested on da850 EVM.

I need Tony Lindgrens ACK on this before I apply it.

Thanks,
Linus Walleij
