Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaCGDbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:31:18 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:35196 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaCGDbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:31:16 -0500
MIME-Version: 1.0
In-Reply-To: <1393842463-5206-1-git-send-email-thloh@altera.com>
References: <1393842463-5206-1-git-send-email-thloh@altera.com>
Date: Fri, 7 Mar 2014 11:31:15 +0800
Message-ID: <CACRpkdbwKuaTucbHbuXsKpRAg+kN27K6uN212TT1-h8wxY9YzA@mail.gmail.com>
Subject: Re: [PATCH V7 1/1] drivers/gpio: Altera soft IP GPIO driver and
 devicetree binding
From: Linus Walleij <linus.walleij@linaro.org>
To: Tien Hock Loh <thloh@altera.com>, Gerhard Sittig <gsi@denx.de>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        "lftan@altera.com" <lftan@altera.com>,
        Tien Hock Loh <thloh.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 6:27 PM,  <thloh@altera.com> wrote:

> From: Tien Hock Loh <thloh@altera.com>
>
> Add driver support for Altera GPIO soft IP, including interrupts and I/O.
> Tested on Altera CV SoC board using dipsw and LED using LED framework.
>
> Signed-off-by: Tien Hock Loh <thloh@altera.com>

Can I get some ACKs on this? Like from Gerhard, DT folks?

Or is there still more things to do?

Yours,
Linus Walleij
