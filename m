Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbaCEBCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:02:00 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:33549 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952AbaCEBB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:01:57 -0500
MIME-Version: 1.0
In-Reply-To: <1393369261-17469-1-git-send-email-delicious.quinoa@gmail.com>
References: <1393369261-17469-1-git-send-email-delicious.quinoa@gmail.com>
Date: Wed, 5 Mar 2014 09:01:56 +0800
Message-ID: <CACRpkdbSk3Vv+-U=jQTH=8E=yx4tkHApGq-ARfwXs-cBf4=ddA@mail.gmail.com>
Subject: Re: [PATCH v12] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
From: Linus Walleij <linus.walleij@linaro.org>
To: Alan Tull <delicious.quinoa@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Rutland <mark.rutland@arm.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 7:01 AM, Alan Tull <delicious.quinoa@gmail.com> wrote:

> From: Jamie Iles <jamie@jamieiles.com>
>
> The Synopsys DesignWare block is used in some ARM devices (picoxcell)
> and can be configured to provide multiple banks of GPIO pins.
>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Signed-off-by: Alan Tull <atull@altera.com>
> Reviewed-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>
> v12: - Add irq_startup/shutdown
>      - do irq_create_mapping() in probe, irq_find_mapping() in to_irq()
>      - Adjust mappings to show support for 1 gpio per port.
>      - gpio-cells = <1>

Patch applied!

You've done a tremendous work on this driver and there is
absolutely nothing controversial about the bindings, so it is
my pleasure to include this driver.

Yours,
Linus Walleij
