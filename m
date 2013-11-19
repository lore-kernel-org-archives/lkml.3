Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab3KSIhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:37:11 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:44265 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3KSIhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:37:07 -0500
MIME-Version: 1.0
In-Reply-To: <1384431530-2166-1-git-send-email-r.sricharan@ti.com>
References: <1384431530-2166-1-git-send-email-r.sricharan@ti.com>
Date: Tue, 19 Nov 2013 09:37:06 +0100
Message-ID: <CACRpkdYM1XcBAznCpmPU+j2kHFPKYA98OAYrpLhcSJr4KbRZzA@mail.gmail.com>
Subject: Re: [PATCH V4 0/4] DRIVERS: IRQCHIP: Add support for crossbar IP
From: Linus Walleij <linus.walleij@linaro.org>
To: Sricharan R <r.sricharan@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        ext Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robherring2@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>, Nishanth Menon <nm@ti.com>,
        Benoit Cousson <bcousson@baylibre.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 1:18 PM, Sricharan R <r.sricharan@ti.com> wrote:

> The minimal crossbar driver to track and allocate free GIC lines and configure the
> crossbar is added here, along with the DT bindings.
>
> V4:
>    Addressed a couple of comments and split the DTS file updates in to
>    a separate series.

I'm pretty happy with the work and effort put into this now it's looking
real elegant.
FWIW: Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
