Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab3A1KQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:16:36 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:64169 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3A1KQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:16:35 -0500
MIME-Version: 1.0
In-Reply-To: <1359133168-14879-2-git-send-email-gregory.clement@free-electrons.com>
References: <1359133168-14879-1-git-send-email-gregory.clement@free-electrons.com>
	<1359133168-14879-2-git-send-email-gregory.clement@free-electrons.com>
Date: Mon, 28 Jan 2013 11:16:34 +0100
Message-ID: <CACRpkdYXfCJgMYJtqn3YwLDw6kGQniMiwUv-C861o-0XbHZrBA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: pca953x: use simple irqdomain
From: Linus Walleij <linus.walleij@linaro.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 5:59 PM, Gregory CLEMENT
<gregory.clement@free-electrons.com> wrote:

> This switches the legacy irqdomain to the simple one, which will
> auto-allocate descriptors, and also make sure that we use
> irq_create_mapping() in the to_irq function. Also use the map function
> of irq_domain_ops to setup the irq configuration on demand and no more
> statically during the initialization of the driver.
>
> Based on a initial patch from Linus Walleij <linus.walleij@linaro.org>
>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Patch applied!

Thanks,
Linus Walleij
